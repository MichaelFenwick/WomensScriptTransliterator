part of womens_script_transliterator;

class EpubTransliterator<S extends Script, T extends Script> extends StructureTransliterator<EpubBook, S, T> {
  EpubTransliterator({
    super.dictionary,
    super.mode = const Mode(),
    super.outputWriter = const StdoutWriter(),
    super.debugWriter = const StderrWriter(),
  });

  static EpubTransliterator<S, T> fromTransliterator<S extends Script, T extends Script>(Transliterator<dynamic, S, T> transliterator) =>
      EpubTransliterator<S, T>(
        dictionary: transliterator.dictionary,
        mode: transliterator.mode,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  ResultPair<EpubBook, S, T> transliterate(EpubBook input, {bool useOutputWriter = false}) {
    final EpubBook transliteratedEpubBook = EpubBook()
      ..Author = input.Author
      ..AuthorList = input.AuthorList
      ..Chapters = input.Chapters
      ..Content = input.Content
      ..CoverImage = input.CoverImage
      ..Schema = input.Schema
      ..Title = input.Title;
    final ResultPair<EpubBook, S, T> result = ResultPair<EpubBook, S, T>(input, transliteratedEpubBook);

    //add font
    final String womensScriptFontFilePath = addFont(result);
    //use font path to create css and add it
    addCss(result, womensScriptFontFilePath);
    //transliterate chapters - use css path to add the styling to them
    transliterateHtmlFiles(result);
    //transliterate metadata (toc, title, etc.)
    transliterateToc(result);
    return result;
  }

  void transliterateHtmlFiles(ResultPair<EpubBook, S, T> epubBookResult) {
    final EpubHtmlFileTransliterator<S, T> epubHtmlFileTransliterator = EpubHtmlFileTransliterator.fromTransliterator(this);
    for (final String? fileName in epubBookResult.source.Content!.Html!.keys) {
      final EpubTextContentFile transliteratedContentFile = epubHtmlFileTransliterator.transliterate(epubBookResult.source.Content!.Html![fileName]!).target;
      setEpubFile(epubBookResult.target, transliteratedContentFile);
    }
  }

  String getContentFileDirectory(String filePath) => path.dirname(filePath);

  String addFont(ResultPair<EpubBook, S, T> result) {
    final Map<String?, EpubByteContentFile> fontFiles = result.source.Content?.Fonts ?? <String?, EpubByteContentFile>{};
    final String fontDirectory = fontFiles.isNotEmpty ? getContentFileDirectory(fontFiles.keys.first!) : 'fonts';
    const String womensScriptFontFileName = 'womens_script.otf';
    final String womensScriptFontFilePath = path.join(fontDirectory, womensScriptFontFileName);
    // Read the font from this project to be inserted into the epub
    final Uint8List womensScriptFont = File(path.join('data', womensScriptFontFileName)).readAsBytesSync();
    final EpubByteContentFile womensScriptFontContentFile = EpubByteContentFile()
      ..Content = womensScriptFont
      ..ContentMimeType = 'application/vnd.ms-opentype'
      ..ContentType = EpubContentType.FONT_OPENTYPE
      ..FileName = womensScriptFontFilePath;
    setEpubFile(result.target, womensScriptFontContentFile);
    return womensScriptFontFilePath;
  }

  void addCss(ResultPair<EpubBook, S, T> result, String womensScriptFontFilePath) {
    final Map<String?, EpubTextContentFile> cssFiles = result.target.Content?.Css ?? <String?, EpubTextContentFile>{};
    final String styleDirectory = cssFiles.isNotEmpty ? getContentFileDirectory(cssFiles.keys.first!) : 'styles';
    final String womensScriptStyleFilePath = path.join(styleDirectory, 'womens_script_style.css');
    final EpubTextContentFile womensScriptStyleContentFile = EpubTextContentFile()
      ..Content = '''
@font-face {
  font-family: "Women's Script";
  font-weight: normal;
  font-style: normal;
  src:url('${path.relative(womensScriptFontFilePath, from: styleDirectory)}') format('otf');
  }
body {
    font-family: "Women's Script" !important;
    font-size: 60px !important;
    line-height: 0.9em !important;
    font-style: italic !important;
  }
  '''
      ..FileName = womensScriptStyleFilePath
      ..ContentType = EpubContentType.CSS
      ..ContentMimeType = 'text/css';

    setEpubFile(result.target, womensScriptStyleContentFile);
  }

  void setTitle(ResultPair<EpubBook, S, T> result) {
    result.target.Title = '${result.source.Title} Transliterated into the Women\'s Script';
  }

  // Transliterate the chapter title in the ToC and Spine
  // The table of contents is a file defined in the manifest. That file is identified as the ToC by having a manifest entry with an id equal to the TableOfContents value in the Spine.
  void transliterateToc(ResultPair<EpubBook, S, T> result) {
    final EpubPackage? epubPackage = result.source.Schema?.Package;
    if (epubPackage == null) {
      throw ArgumentError.notNull('result.source.Schema.Package');
    }
    final String? tocId = epubPackage.Spine!.TableOfContents;
    if (tocId != null) {
      final EpubManifestItem tocManifestItem = epubPackage.Manifest!.Items!.where((EpubManifestItem item) => item.Id == tocId).first;
      final EpubByteContentFile tocByteFile = result.source.Content!.AllFiles![tocManifestItem.Href] as EpubByteContentFile;
      final String tocContent = String.fromCharCodes(tocByteFile.Content!);
      final EpubTextContentFile tocTextFile = EpubTextContentFile()
        ..Content = tocContent
        ..ContentMimeType = tocByteFile.ContentMimeType
        ..ContentType = tocByteFile.ContentType
        ..FileName = tocByteFile.FileName;
      final EpubTextContentFile transliteratedTocTextFile =
          (EpubHtmlFileTransliterator.fromTransliterator(this)..mode = const Mode(treatAsFragment: true)).transliterate(tocTextFile).target;
      final EpubByteContentFile transliteratedTocByteFile = EpubByteContentFile()
        ..Content = transliteratedTocTextFile.Content!.codeUnits
        ..ContentMimeType = tocByteFile.ContentMimeType
        ..ContentType = tocByteFile.ContentType
        ..FileName = tocByteFile.FileName;
      setEpubFile(result.target, transliteratedTocByteFile);
    }
  }

  /// Adds or replaces a [contentFile] in the provided [epubBook]. The [EpubContentFile.FileName] will be used to identify the file to replace, or the path and name of the file to add. The [EpubContentFile.FileName] is relative to the [epubBook]'s internal root directory.
  void setEpubFile(EpubBook epubBook, EpubContentFile contentFile) {
    // Epub paths MUST be separated by forward slashes. Before writing, replace any occurrences of a back slash with a forward slash to ensure this is satisfied.
    final String normalizedFileName = contentFile.FileName?.replaceAll(r'\', '/') ?? '';
    final EpubContentFile? epubBookFile = epubBook.Content!.AllFiles![contentFile.FileName];
    if (epubBookFile == null) {
      epubBook.Schema!.Package!.Manifest!.Items!.add(EpubManifestItem()
        ..Id = path.basename(normalizedFileName)
        ..Href = normalizedFileName
        ..MediaOverlay
        ..MediaType = contentFile.ContentMimeType
        ..Properties
        ..RequiredNamespace
        ..RequiredModules
        ..Fallback
        ..FallbackStyle);
    }
    epubBook.Content!.AllFiles![normalizedFileName] = contentFile;
  }
}
