part of transliterator;

class XmlTransliterator<S extends Language, T extends Language> extends StructureTransliterator<XmlDocument, S, T> {
  XmlTransliterator({
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static XmlTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      XmlTransliterator<S, T>(
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  ResultPair<XmlDocument, S, T> transliterate(XmlDocument input, {bool useOutputWriter = false, Iterable<String> whitelist = const <String>[]}) {
    final XmlDocument inputCopy = input.copy();
    final TextBlockTransliterator<S, T> textBlockTransliterator = TextBlockTransliterator.fromTransliterator(this);

    //TODO: The logic of which elements to process should belong to the epubChapterTransliterator. Probably should have it pass in something (just use the whitelist?). This logic should collect all the block nodes which are direct descendants of the document's <body>.
    input.descendants.whereType<XmlElement>().where((XmlElement element) => element.name.local == 'div').forEach((XmlElement div) {
      final Iterable<Result<Atom<TextBlock, XmlText>, S, T>?> results = textBlockTransliterator.transliterateAtoms<XmlText>(
          div.descendants.whereType<XmlText>().map((XmlText node) => Atom<TextBlock, XmlText>(TextBlock(node.text), node)).toList());
      for (final Result<Atom<TextBlock, XmlText>, S, T>? result in results) {
        if (result is ResultPair<Atom<TextBlock, XmlText>, S, T>) {
          result.target.context.replace(XmlText(result.target.content.content));
        }
      }
    });

    return ResultPair<XmlDocument, S, T>(inputCopy, input);
  }
}
