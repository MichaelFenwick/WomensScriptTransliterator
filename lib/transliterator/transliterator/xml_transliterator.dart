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
    final ParagraphTransliterator<S, T> paragraphTransliterator = ParagraphTransliterator.fromTransliterator<S, T>(this);

    //FIXME: Inline tags cause the string transliterators to create new sentences on their boundaries, even if the tag exists inside of a sentence. This needs to find a way to pass only block level tags to the paragraphTransliterator if there are no inline tags, and to do something more nuanced if there are inline tags to ensure things don't get messed up. One method might be to create functionality inside of the paragraphTransliterator to allow it to be passed an iterable of strings, which it would process as though they were concatted together for the purposes of punctuation, sentence stars, etc., but which would return in the same pieces it was sent. The XmlTransliterator then could split up contents of any block level tags (pre inline tag, inline tag contents [inter inline tag contents, inline tag contents]*, post inline tag contents) and then put the returned pieces back in the appropriate tags, without having to know anything about how sentences work itself.
    input.descendants.where((XmlNode node) => node is XmlText && node.text.trim().isNotEmpty).toList().forEach((XmlNode node) {
      final Result<String, S, T> result = paragraphTransliterator.transliterate(node.text);
      if (result is ResultPair) {
        node.replace(XmlText((result as ResultPair<String, S, T>).target));
      }
    });

    return ResultPair<XmlDocument, S, T>(inputCopy, input);
  }
}
