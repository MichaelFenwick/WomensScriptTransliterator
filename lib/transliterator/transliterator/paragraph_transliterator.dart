part of transliterator;

class ParagraphTransliterator<S extends Language, T extends Language> extends StringTransliterator<S, T> {
  static final Pattern sentenceSeparators = RegExp(
      r'([.!?"]\)?)(\s+)(["\(])?'); //TODO: Figure out what the right regex for breaking a paragraph into sentences is. It should work for quotes in dialog as well as things like parentheticals or sentences that start/trail off with ellipses. The regex should have three parts, an "ending punctuation" of the preceding sentence, one or more whitespace characters between the sentences, and "leading punctuation" of the following sentence. This is fairly close to what it needs to be for now though.
  //TODO: Add a lookbehind so this doesn't match if the closing punctuation is a . preceded by a single letter which is preceded by a . or space (for people whose names are initialized).
  //TODO: Also, this is making empty string sentences/words when a line has no text (as in two \n in a row). Instead, it should capture all contiguous whitespace between sentences.

  ParagraphTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static ParagraphTransliterator<S, T> fromTransliterator<E, S extends Language, T extends Language>(Transliterator<E, S, T> transliterator) =>
      ParagraphTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  static String sentenceReducer(String a, String b) => '$a $b';

  @override
  Result<String, S, T> transliterate(String input, {bool useOutputWriter = true}) {
    //TODO: It would be better to pull apart the sentences while keeping the punctuation and spaces tied to it. For now just throwing that away will be fine.
    final List<String> words = input.split(sentenceSeparators);
    final SentenceTransliterator<S, T> sentenceTransliterator = SentenceTransliterator.fromTransliterator<String, S, T>(this);
    final Iterable<Result<String, S, T>> sentenceResults = sentenceTransliterator.transliterateAll(words, useOutputWriter: useOutputWriter);

    //TODO: Append/postpend an extra Result or two to the sentenceResults iterable to add the appropriate whitespace back in as necessary.
    final Result<String, S, T> result = Result.join<String, S, T>(sentenceResults, sourceReducer: sentenceReducer, targetReducer: sentenceReducer);
    if (useOutputWriter) {
      outputWriter.writeln(result);
    }
    return result;
  }
}
