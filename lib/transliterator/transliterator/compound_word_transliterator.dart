part of transliterator;

class CompoundWordTransliterator<S extends Language, T extends Language> extends StringTransliterator<S, T> {
  CompoundWordTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static CompoundWordTransliterator<S, T> fromTransliterator<E, S extends Language, T extends Language>(Transliterator<E, S, T> transliterator) =>
      CompoundWordTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Result<String, S, T> transliterate(String input, {bool useOutputWriter = false}) {
    final WordTransliterator<S, T> wordTransliterator = WordTransliterator.fromTransliterator<String, S, T>(this);
    final Result<String, S, T> result = Result.splitMapJoin<S, T>(
      input,
      RegExp('[A-Za-z0-9]+'),
      onMatch: (Match match) => wordTransliterator.transliterate(match[0]!),
      onNonMatch: (String nonMatch) => ResultPair<String, S, T>.fromValue(nonMatch),
    );

    if (useOutputWriter) {
      outputWriter.writeln(result);
    }

    return result;
  }
}
