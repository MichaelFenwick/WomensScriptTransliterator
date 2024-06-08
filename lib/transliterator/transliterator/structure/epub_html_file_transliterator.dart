part of womens_script_transliterator;

class EpubHtmlFileTransliterator<S extends Language, T extends Language> extends StructureTransliterator<EpubTextContentFile, S, T> {
  EpubHtmlFileTransliterator({
    super.dictionary,
    super.mode = const Mode(),
    super.outputWriter = const StdoutWriter(),
    super.debugWriter = const StderrWriter(),
  });


  static EpubHtmlFileTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      EpubHtmlFileTransliterator<S, T>(
        dictionary: transliterator.dictionary,
        mode: transliterator.mode,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  ResultPair<EpubTextContentFile, S, T> transliterate(EpubTextContentFile input, {bool useOutputWriter = false}) {
    final EpubTextContentFile transliteratedContentFile = EpubTextContentFile()
      ..Content = input.Content
      ..ContentMimeType = input.ContentMimeType
      ..ContentType = input.ContentType
      ..FileName = input.FileName;

    if (input.Content != null) {
      final XmlTransliterator<S, T> xmlTransliterator = XmlTransliterator.fromTransliterator<S, T>(this);
      final XmlDocument contentFileXml = XmlDocument.parse(input.Content ?? '');
      final ResultPair<XmlDocument, S, T> transliterationResult = xmlTransliterator.transliterate(contentFileXml);

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
          final SentenceTransliterator<S, T> sentenceTransliterator = SentenceTransliterator.fromTransliterator<S, T>(this);
          final ResultPair<Sentence, S, T> titleTransliterationResult =
              sentenceTransliterator.transliterate(Sentence(titleElement.innerText)) as ResultPair<Sentence, S, T>;
          titleElement.innerText = titleTransliterationResult.target.content;
        }
      }

      transliteratedContentFile.Content = transliterationResult.target.toXmlString();
    }

    return ResultPair<EpubTextContentFile, S, T>(input, transliteratedContentFile);
  }
}
