part of transliterator;

class SentenceTransliterator<S extends Language, T extends Language> extends StringTransliterator<S, T> {
  static final Pattern wordSeparators = RegExp('[^a-zA-Z0-9]+');

  SentenceTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static SentenceTransliterator<S, T> fromTransliterator<E, S extends Language, T extends Language>(Transliterator<E, S, T> transliterator) =>
      SentenceTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  static String wordReducer(String a, String b) => '$a $b';
  static String punctuationReducer(String a, String b) => '$a$b';

  @override
  Result<String, S, T> transliterate(String input, {bool useOutputWriter = true}) {
    final RegExp sentencePunctuation = RegExp(r'^([^\w\s]*)([\w\s]+)([^\w\s]*)$');
    final RegExpMatch? sentencePunctuationMatches = sentencePunctuation.firstMatch(input);
    final String? sentenceWords = sentencePunctuationMatches?.group(2);
    final String? closingPunctuation = sentencePunctuationMatches?.group(3);
    final List<String> words = (sentenceWords ?? input).split(wordSeparators);
    final WordTransliterator<S, T> wordTransliterator = WordTransliterator.fromTransliterator<String, S, T>(this);
    final Iterable<Result<String, S, T>> wordResults = wordTransliterator.transliterateAll(words, useOutputWriter: useOutputWriter);
    final Result<String, S, T> reducedWordResult = Result.join<String, S, T>(wordResults, sourceReducer: wordReducer, targetReducer: wordReducer);

    //FIXME: The following punctuation logic assumes an English->Alethi transliteration. These rules should be abstracted so they can vary depending on the transliteration languages.
    final Result<String, S, T> leadingPeriod = reducedWordResult is EmptyResult ? ResultPair<String, S, T>('', '') : ResultPair<String, S, T>('', '.');
    final Result<String, S, T> trailingQuestion =
        closingPunctuation?.contains('?') == true ? ResultPair<String, S, T>('?', 'ha') : ResultPair<String, S, T>('', '');

    final Result<String, S, T> finalResult =
        Result.join<String, S, T>([leadingPeriod, reducedWordResult, trailingQuestion], sourceReducer: punctuationReducer, targetReducer: punctuationReducer);
    if (useOutputWriter) {
      outputWriter.writeln(finalResult);
    }
    return finalResult;
  }
}
