part of womens_script_transliterator;

class EpubHtmlFileTransliterator extends StructureTransliterator<EpubTextContentFile> {
  EpubHtmlFileTransliterator({
    required super.direction,
    super.dictionary,
    super.mode = const Mode(),
    super.outputWriter = const StdoutWriter(),
    super.debugWriter = const StderrWriter(),
  });

  EpubHtmlFileTransliterator.fromTransliterator(Transliterator<dynamic> transliterator)
      : super(
          direction: transliterator.direction,
          dictionary: transliterator.dictionary,
          mode: transliterator.mode,
          outputWriter: transliterator.outputWriter,
          debugWriter: transliterator.debugWriter,
        );

  @override
  ResultPair<EpubTextContentFile> transliterate(EpubTextContentFile input, {bool useOutputWriter = false}) {
    final EpubTextContentFile transliteratedContentFile = EpubTextContentFile()
      ..Content = input.Content
      ..ContentMimeType = input.ContentMimeType
      ..ContentType = input.ContentType
      ..FileName = input.FileName;

    if (input.Content != null) {
      final XmlTransliterator xmlTransliterator = XmlTransliterator.fromTransliterator(this);
      final XmlDocument contentFileXml = XmlDocument.parse(input.Content ?? '');
      final ResultPair<XmlDocument> transliterationResult = xmlTransliterator.transliterate(contentFileXml);

      // Add an html header to define the css to use
      final XmlElement? head = transliterationResult.target.descendants
          .whereType<XmlElement?>()
          .firstWhere((XmlElement? element) => element?.name.local == 'head', orElse: () => null);
      if (head != null) {
        final XmlBuilder xmlBuilder = XmlBuilder()
          ..element('link', attributes: <String, String>{
            'rel': 'stylesheet',
            'type': 'text/css',
            'href': '../styles/womens_script_style.css', //FIXME: This should be the appropriate relative path and filename.
          });
        head.children.add(xmlBuilder.buildFragment());

        // Chapter files have a title title which is separate from the chapter's text. This title needs to be manually transliterated as its own sentence.
        final XmlElement? titleElement =
            head.children.whereType<XmlElement?>().firstWhere((XmlElement? element) => element?.name.local == 'title', orElse: () => null);
        if (titleElement != null) {
          final SentenceTransliterator sentenceTransliterator = SentenceTransliterator.fromTransliterator(this);
          final ResultPair<Sentence> titleTransliterationResult =
              sentenceTransliterator.transliterate(Sentence(titleElement.innerText)) as ResultPair<Sentence>;
          titleElement.innerText = titleTransliterationResult.target.content;
        }
      }

      transliteratedContentFile.Content = transliterationResult.target.toXmlString();
    }

    return ResultPair<EpubTextContentFile>(input, transliteratedContentFile);
  }
}
