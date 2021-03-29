part of transliterator;

class EpubTransliterator<S extends Language, T extends Language> extends StructureTransliterator<File, S, T> {
  EpubTransliterator({
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static EpubTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      EpubTransliterator<S, T>(
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Future<ResultPair<File, S, T>> transliterate(File input, {bool useOutputWriter = false}) async {
    final Directory epubDirectory = input.parent;
    final Directory unzippedEpubDirectory = await unzipEpub(input);

    final EpubChapterTransliterator<S, T> epubChapterTransliterator = EpubChapterTransliterator.fromTransliterator<S, T>(this);
    final File contentOpfFile = File(path.join(unzippedEpubDirectory.path, 'content.opf'));
    final File cssFile = File(path.join(unzippedEpubDirectory.path, 'stylesheet.css'));
    final List<FileSystemEntity> chapterFiles = await unzippedEpubDirectory.list().where((FileSystemEntity entity) => entity.path.endsWith('.html')).toList();

    if (contentOpfFile.existsSync() && cssFile.existsSync()) {
      await Future.wait(<Future<void>>[
        ...chapterFiles.map<Future<ResultPair<File, S, T>>>((FileSystemEntity entity) {
          final File chapterFile = entity as File;
          return epubChapterTransliterator.transliterate(chapterFile);
        }),
        if (contentOpfFile.existsSync() && cssFile.existsSync()) ...<Future<File>>[
          addFontToEpub(unzippedEpubDirectory),
          addFontToManifest(contentOpfFile),
          addFontToCss(unzippedEpubDirectory),
        ],
      ]);
    } else {
      throw FileSystemException(
          'Expected files ${contentOpfFile.path} and ${cssFile.path} to exist in the epub to be transliterated. Check to make sure that the epub is properly formatted.');
    }

    final String transliteratedEpubFilename = path.join(epubDirectory.path, '${path.basenameWithoutExtension(input.path)}_transliterated.epub');
    final File transliteratedEpubFile = zipEpub(unzippedEpubDirectory, File(transliteratedEpubFilename));

    await deleteUnzippedEpubDirectory(unzippedEpubDirectory);

    return ResultPair<File, S, T>(input, transliteratedEpubFile);
  }

  Future<File> addFontToEpub(Directory unzippedEpubDirectory) async {
    const String fontFileName = 'womens_script.otf';
    final File fontFile = File(path.join('data', fontFileName));

    return fontFile.copy(unzippedEpubDirectory.path + fontFileName);
  }

  Future<File> addFontToManifest(File contentOpfFile) async {
    final XmlDocument contentOpfXml = XmlDocument.parse(await contentOpfFile.readAsString());

    contentOpfXml.getElement('package')?.getElement('manifest')?.children.add(XmlElement(
          XmlName('item'),
          <XmlAttribute>[
            XmlAttribute(XmlName('href'), 'womens_script.otf'),
            XmlAttribute(XmlName('media-type'), 'application/vnd.ms-opentype'),
            XmlAttribute(XmlName('id'), 'font.WomensScript.regular')
          ],
        ));

    final XmlElement? titleElement = contentOpfXml.getElement('package')?.getElement('metadata')?.getElement('dc:title');
    if (titleElement != null) {
      final String title = titleElement.text;
      contentOpfXml.getElement('package')?.getElement('metadata')?.getElement('dc:title')?.replace(XmlElement(
            XmlName('dc:title'),
            <XmlAttribute>[],
            <XmlText>[XmlText('$title Transliterated')],
          ));
    }

    return contentOpfFile.writeAsString(contentOpfXml.toXmlString());
  }

  //TODO: It would be much better to actually parse the css file and update the styles where applicable rather than attempt to override them.
  Future<File> addFontToCss(Directory unzipDirectory) async {
    final File cssFile = File('${unzipDirectory.path}stylesheet.css');
    final String cssFileString = await cssFile.readAsString();
    const String fontDirectives = '''
@font-face {
  font-family: "Women's Script";
  font-weight: normal;
  font-style: normal;
  src:url('womens_script.otf') format('otf');
  }
body {
    font-family: "Women's Script";
    font-size: 96px !important;
    line-height: 0.9em !important;
    font-style: italic !important;
  }
p {
    margin-bottom: 0.5em !important;
    text-indent: 0.5em !important;
  }
.italic {
  font-style: normal !important;
  }
.bold {
  font-weight: 500 !important;
  }
  ''';

    return cssFile.writeAsString(cssFileString + fontDirectives);
  }

  Future<Directory> unzipEpub(File inputFile) async {
    const String unzippedFolderName = 'unzip';
    final Uint8List inputBytes = await inputFile.readAsBytes();
    final Archive archive = ZipDecoder().decodeBytes(inputBytes);

    final Directory unzippedDirectory = Directory(path.join(path.dirname(inputFile.path), unzippedFolderName));
    if (unzippedDirectory.existsSync()) {
      throw FileSystemException('Expected directory ${unzippedDirectory.path} to not exist. Please delete or rename this directory any try again.');
    } else {
      await unzippedDirectory.create(recursive: true);
    }

    await Future.wait(archive.map<Future<FileSystemEntity>>((ArchiveFile file) {
      final String filename = file.name;
      if (file.isFile) {
        final List<int> data = file.content as List<int>;
        return File(path.join(unzippedDirectory.path, filename)).create(recursive: true).then((File file) => file.writeAsBytes(data));
      } else {
        return Directory(path.join(unzippedDirectory.path, filename)).create(recursive: true);
      }
    }));

    return unzippedDirectory;
  }

  File zipEpub(Directory unzippedEpubDirectory, File outputFile) {
    ZipFileEncoder().zipDirectory(unzippedEpubDirectory, filename: outputFile.path);
    return outputFile;
  }

  Future<FileSystemEntity> deleteUnzippedEpubDirectory(Directory unzippedEpubDirectory) => unzippedEpubDirectory.delete(recursive: true);
}
