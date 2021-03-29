part of transliterator;

class ParagraphTransliterator<S extends Language, T extends Language> extends StringTransliterator<S, T> {
  static final Pattern sentencePattern = RegExp(r'.+?(([.!?"”\)]+\s+)|$)');
  //TODO: Do some research to see what characters can reasonably be expected to be the end of a sentence. Make sure to include things like fancy quotes (single and double) and other such variations.
  //TODO: Add a lookbehind so this doesn't match if the closing punctuation is a . preceded by a single letter which is preceded by a . or space (for people whose names are initialized).

  ParagraphTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static ParagraphTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      ParagraphTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Result<String, S, T> transliterate(String input, {bool useOutputWriter = false}) {
    final SentenceTransliterator<S, T> sentenceTransliterator = SentenceTransliterator.fromTransliterator<S, T>(this);
    final Result<String, S, T> result = Result.splitMapJoin(
      input,
      sentencePattern,
      onMatch: (Match match) => sentenceTransliterator.transliterate(match[0]!),
      onNonMatch: (String nonMatch) => ResultPair<String, S, T>.fromValue(nonMatch),
    );

    if (useOutputWriter) {
      outputWriter.writeln(result);
    }

    return result;
  }
}
