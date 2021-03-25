part of transliterator;

class SentenceTransliterator<S extends Language, T extends Language> extends StringTransliterator<S, T> {
  static final Pattern wordPattern = RegExp(r'[^\s]+');

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

  static String punctuationReducer(String a, String b) => '$a$b';

  @override
  Result<String, S, T> transliterate(String input, {bool useOutputWriter = false}) {
    final CompoundWordTransliterator<S, T> compoundWordTransliterator = CompoundWordTransliterator.fromTransliterator<String, S, T>(this);
    final RegExp sentencePunctuationPattern = RegExp(r'^([^\w\s]+)?(.+?)([^\w\s]+\s*)?$');
    final RegExpMatch? sentencePunctuationMatches = sentencePunctuationPattern.firstMatch(input);
    final String? openingPunctuation = sentencePunctuationMatches?.group(1);
    final String? sentenceWords = sentencePunctuationMatches?.group(2);
    final String? closingPunctuation = sentencePunctuationMatches?.group(3);
    final Result<String, S, T> wordResult = Result.splitMapJoin(
      sentenceWords ?? input,
      wordPattern,
      onMatch: (Match match) => compoundWordTransliterator.transliterate(match[0]!),
      onNonMatch: (String nonMatch) => ResultPair<String, S, T>.fromValue(nonMatch),
    );

    //FIXME: The following punctuation logic assumes an English->Alethi transliteration. These rules should be abstracted so they can vary depending on the transliteration languages.
    final RegExp openingQuotePattern = RegExp('[“"\']');
    final int openingQuoteIndex = (openingPunctuation ?? '').indexOf(openingQuotePattern);
    final String newOpeningPunctuation =
        '${(openingPunctuation ?? '').substring(0, openingQuoteIndex + 1)}${openingQuoteIndex > -1 ? '' : '.'}${(openingPunctuation ?? '').substring(openingQuoteIndex + 1)}';
    final Result<String, S, T> openingPunctuationResult =
        wordResult is EmptyResult ? ResultPair<String, S, T>('', '') : ResultPair<String, S, T>(openingPunctuation ?? '', newOpeningPunctuation);
    //FIXME: This will break if more than one period is in the closing punctuation. I should look out for ellipses and weirdness with quotes/parentheticals in the replacement.
    final Result<String, S, T> closingPunctuationResult = closingPunctuation != null
        ? ResultPair<String, S, T>(closingPunctuation, closingPunctuation.replaceFirst(RegExp('[!.]'), ''))
        : ResultPair<String, S, T>('', '');

    final Result<String, S, T> finalResult = Result.join<String, S, T>(<Result<String, S, T>>[openingPunctuationResult, wordResult, closingPunctuationResult],
        sourceReducer: punctuationReducer, targetReducer: punctuationReducer);

    if (useOutputWriter) {
      outputWriter.writeln(finalResult);
    }

    return finalResult;
  }
}
