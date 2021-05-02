part of transliterator;

class SentenceTransliterator<S extends Language, T extends Language> extends StringTransliterator<Sentence, S, T>
    with SuperUnitStringTransliterator<Sentence, S, T> {
  SentenceTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static SentenceTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      SentenceTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Result<Sentence, S, T> transliterate(Sentence input, {bool useOutputWriter = false}) {
    final WordTransliterator<S, T> wordTransliterator = getSubtransliterator();
    final RegExp sentencePunctuationPattern = RegExp(r'^([^\w\s]+)?(.+?)([^\w\s]+\s*)?$');
    final RegExpMatch? sentencePunctuationMatches = sentencePunctuationPattern.firstMatch(input.content);
    final String? openingPunctuation = sentencePunctuationMatches?.group(1);
    final String? sentenceWords = sentencePunctuationMatches?.group(2);
    final String? closingPunctuation = sentencePunctuationMatches?.group(3);
    final Result<Sentence, S, T> wordResult = splitMapJoin(sentenceWords != null ? Sentence(sentenceWords) : input,
        onMatch: (Match match) => wordTransliterator.transliterate(wordTransliterator.buildUnit(match[0]!, isComplete: true)),
        onNonMatch: cleanNonWordCharacters);

    final int openingQuoteIndex = (openingPunctuation ?? '').indexOf(openingQuotePattern);
    final String newOpeningPunctuation =
        '${(openingPunctuation ?? '').substring(0, openingQuoteIndex + 1)}${openingQuoteIndex > -1 ? '' : leadingPeriod}${(openingPunctuation ?? '').substring(openingQuoteIndex + 1)}';
    final Result<Sentence, S, T> openingPunctuationResult = wordResult is EmptyResult
        ? ResultPair<Sentence, S, T>.fromValue(buildUnit('', isComplete: false))
        : ResultPair<Sentence, S, T>(buildUnit(openingPunctuation ?? '', isComplete: false), buildUnit(newOpeningPunctuation, isComplete: false));
    final Result<Sentence, S, T> closingPunctuationResult = closingPunctuation != null
        ? ResultPair<Sentence, S, T>(
            buildUnit(closingPunctuation, isComplete: false), buildUnit(closingPunctuation.replaceFirst(RegExp('[!.]+'), ''), isComplete: false))
        : ResultPair<Sentence, S, T>.fromValue(buildUnit('', isComplete: false));

    final Result<Sentence, S, T> finalResult = Result.join<Sentence, S, T>(
        <Result<Sentence, S, T>>[openingPunctuationResult, wordResult, closingPunctuationResult],
        sourceReducer: sourceReducer, targetReducer: targetReducer);

    if (useOutputWriter) {
      outputWriter.writeln(finalResult);
    }

    return finalResult;
  }

  static final RegExp openingQuotePattern = RegExp('[“"\'({[]+');
  static final RegExp closingPunctuationPattern = RegExp(r'[^\w\s]+\s*$');
  static final RegExp closingPeriodPattern = RegExp(r'!|(\.(?!\.\.))');
  static const String leadingPeriod = '.${Unicode.zeroWidthNoneBreakingSpace}';

  ResultPair<Word, S, T> cleanNonWordCharacters(String input) {
    final String cleanedString = input
        .replaceAll(RegExp('\\s*${Unicode.emDash}\\s*'), ' ${Unicode.emDash} ') // Make sure em dashes have spaces surrounding them
        .replaceAll(RegExp(r'(?<!^[.\s]*)…(?=[a-zA-Z])'),
            '${Unicode.ellipsis} '); // Make sure ellipses have a space after them, but only if they are followed by a letter and not at the start of the sentence.
    return ResultPair<Word, S, T>(Word(input), Word(cleanedString));
  }

  @override
  Iterable<Result<Atom<Sentence, X>, S, T>?> transliterateAtoms<X>(List<Atom<StringUnit, X>?> unitAtoms) {
    final int firstAtomIndex = unitAtoms.indexWhere((Atom<StringUnit, X>? atom) => atom != null);
    final int lastAtomIndex = unitAtoms.lastIndexWhere((Atom<StringUnit, X>? atom) => atom != null);
    if (firstAtomIndex >= 0 && lastAtomIndex >= 0) {
      // Remove periods and exclamation points from the end of the sentence. Note that this has to happen first, otherwise the period we add to the start of a sentence might get replaced.
      final String closingAtomText = unitAtoms[lastAtomIndex]!.content.content;
      final Iterable<Match> lastPeriodMatches = closingPeriodPattern.allMatches(closingAtomText);
      final Match? lastPeriodMatch = lastPeriodMatches.isNotEmpty ? lastPeriodMatches.last : null;
      if (lastPeriodMatch != null) {
        final Sentence lastAtomNewContent = Sentence(closingAtomText.replaceRange(lastPeriodMatch.start, lastPeriodMatch.end, ''));
        unitAtoms[lastAtomIndex] = unitAtoms[lastAtomIndex]!.withNewContent(lastAtomNewContent);
      }

      // Add a period to the start of the sentence in the appropriate place
      final String firstAtomText = unitAtoms[firstAtomIndex]!.content.content;
      final Match? openingQuotes = openingQuotePattern.matchAsPrefix(firstAtomText);
      Sentence firstAtomNewContent;
      if (openingQuotes != null) {
        firstAtomNewContent =
            Sentence(firstAtomText.substring(openingQuotes.start, openingQuotes.end) + leadingPeriod + firstAtomText.substring(openingQuotes.end));
      } else {
        firstAtomNewContent = Sentence(leadingPeriod + firstAtomText);
      }
      unitAtoms[firstAtomIndex] = unitAtoms[firstAtomIndex]!.withNewContent(firstAtomNewContent);
    }

    return super.transliterateAtoms(
        unitAtoms.map((Atom<StringUnit, X>? atom) => atom?.withNewContent(Sentence(cleanNonWordCharacters(atom.content.content).target.content))).toList());
  }

  @override
  WordTransliterator<S, T> getSubtransliterator() => WordTransliterator.fromTransliterator(this);

  @override
  Sentence buildUnit(String string, {required bool isComplete}) => Sentence(string, isComplete: isComplete);
}
