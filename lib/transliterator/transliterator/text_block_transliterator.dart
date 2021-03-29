part of transliterator;

class TextBlockTransliterator<S extends Language, T extends Language> extends StringTransliterator<S, T> {
  static final Pattern paragraphPattern = RegExp(r'(?<=[\s-])');

  TextBlockTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static TextBlockTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      TextBlockTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Result<String, S, T> transliterate(String input, {bool useOutputWriter = false}) {
    final ParagraphTransliterator<S, T> paragraphTransliterator = ParagraphTransliterator.fromTransliterator<S, T>(this);
    final Result<String, S, T> result = Result.splitMapJoin(
      input,
      paragraphPattern,
      onMatch: (Match match) => paragraphTransliterator.transliterate(match[0]!),
      onNonMatch: (String nonMatch) => ResultPair<String, S, T>.fromValue(nonMatch),
    );

    if (useOutputWriter) {
      outputWriter.writeln(result);
    }

    return result;
  }
}
