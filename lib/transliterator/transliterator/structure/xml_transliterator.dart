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

    input.descendants
        .whereType<XmlElement>()
        .where((XmlElement element) => <String>['p', 'div', 'text'].contains(element.name.local))
        .forEach((XmlElement div) {
      final Iterable<Result<Atom<TextBlock, XmlText>, S, T>?> results = textBlockTransliterator.transliterateAtoms<XmlText>(div.descendants
          .whereType<XmlText>()
          .map((XmlText node) => Atom<TextBlock, XmlText>(
              TextBlock(node.value
                  //FIXME: This is probably the right place for this logic (it needs to happen before the text gets to the SentenceTransliterator, otherwise a final period in the ellipsis might be moved to the sentence's start [see https://github.com/MichaelFenwick/WomensScriptTransliterator/issues/29]). However, this is pretty sloppily shoehorned in and should be pulled into its own method. Perhaps it could be better placed Paragraph transliterator).
                  .replaceAll(RegExp(r'\.(&nbsp;?\.){2,4}'),
                      Unicode.ellipsis) // Replace any poorly formatted ellipsis attempts to an actual ellipsis character.
                  .replaceAll(RegExp('&nbsp;'), ' ')), // And replace any leftover encoded nbsp characters with the actual character
              node))
          .toList());
      for (final Result<Atom<TextBlock, XmlText>, S, T>? result in results) {
        if (result is ResultPair<Atom<TextBlock, XmlText>, S, T>) {
          result.target.context.replace(XmlText(result.target.content.content));
        }
      }
    });

    return ResultPair<XmlDocument, S, T>(inputCopy, input);
  }
}
