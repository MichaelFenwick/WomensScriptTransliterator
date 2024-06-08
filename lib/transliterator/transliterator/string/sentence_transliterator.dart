part of womens_script_transliterator;

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
    final Result<Sentence, S, T> finalResult;
    final Result<Word, S, T> nonSentenceProcessResult = processNonSentences(input.content);
    //FIXME: This isn't actually being called when transliterating an epub, since it all goes through transliterateAtoms instead. Move this check to there, or better, merge this method and that one.
    if (nonSentenceProcessResult is ResultPair<Word, S, T>) {
      finalResult = nonSentenceProcessResult.cast<Sentence>((Word word) => Sentence(word.content));
    } else {
      final WordTransliterator<S, T> wordTransliterator = getSubtransliterator();
      final RegExp sentencePunctuationPattern = RegExp(r'^([^\w\s]+)?(.+?)([^\w\s]+\s*)?$');
      final RegExpMatch? sentencePunctuationMatches = sentencePunctuationPattern.firstMatch(input.content);
      final String? openingPunctuation = sentencePunctuationMatches?.group(1);
      final String? sentenceWords = sentencePunctuationMatches?.group(2);
      final String? closingPunctuation = sentencePunctuationMatches?.group(3);
      final Result<Sentence, S, T> wordResult = splitMapJoin(sentenceWords != null ? Sentence(sentenceWords) : input,
          onMatch: (Match match) => wordTransliterator.transliterate(wordTransliterator.buildUnit(match[0]!)), onNonMatch: cleanNonWordCharacters);

      final int openingQuoteIndex = (openingPunctuation ?? '').indexOf(openingQuotePattern);
      final String newOpeningPunctuation =
          '${(openingPunctuation ?? '').substring(0, openingQuoteIndex + 1)}${openingQuoteIndex > -1 ? '' : leadingPeriod}${(openingPunctuation ?? '').substring(openingQuoteIndex + 1)}';
      final Result<Sentence, S, T> openingPunctuationResult = wordResult is EmptyResult
          ? ResultPair<Sentence, S, T>.fromValue(buildUnit(''))
          : ResultPair<Sentence, S, T>(buildUnit(openingPunctuation ?? ''), buildUnit(newOpeningPunctuation));
      final Result<Sentence, S, T> closingPunctuationResult = closingPunctuation != null
          ? ResultPair<Sentence, S, T>(buildUnit(closingPunctuation), buildUnit(closingPunctuation.replaceFirst(RegExp('[!.]+'), '')))
          : ResultPair<Sentence, S, T>.fromValue(buildUnit(''));

      finalResult = Result.join<Sentence, S, T>(<Result<Sentence, S, T>>[openingPunctuationResult, wordResult, closingPunctuationResult],
          sourceReducer: sourceReducer, targetReducer: targetReducer);
    }

    if (useOutputWriter) {
      outputWriter.writeln(finalResult);
    }

    return finalResult;
  }

  static final RegExp openingQuotePattern = RegExp('[“"\'({[]+');
  static final RegExp closingPunctuationPattern = RegExp(r'[^\w\s]+\s*$');

  // A "closing period" is sentence ending punctuation which is either an exclamation point, or a period which is not part of an ellipsis.
  static final RegExp closingPeriodPattern = RegExp(r'!|((?<!\.)\.(?!\.\.))');
  static const String leadingPeriod = '.${Unicode.zeroWidthNonBreakingSpace}';

  /// Some "sentences" aren't actually a semantic sentence, and shouldn't be parsed as such. Instead, they should have alternative processing applied instead.
  Result<Word, S, T> processNonSentences(String input) {
    final String processedString = input.replaceAll(RegExp(r'\*(\s*\*){2,4}'),
        '__________'); // Asterisks are used as section breaks, but won't display well as they are. Convert them to underscores to get a nice looking line to separate the sections instead.

    if (processedString == input) {
      return EmptyResult<Word, S, T>(Word(input));
    }

    return ResultPair<Word, S, T>(Word(input), Word(processedString));
  }

  //TODO: I have to do some cleaning in the XML Translator as well, currently. I need to find a way to do both this and that cleaning in the same place.
  ResultPair<Word, S, T> cleanNonWordCharacters(String input) {
    final String cleanedString = input
        .replaceAll(RegExp('\\s*${Unicode.emDash}\\s*'), ' ${Unicode.emDash} ') // Make sure em dashes have spaces surrounding them
        .replaceAll(RegExp(r'(?<!^[.\s]*)…(?=[a-zA-Z])'),
            '${Unicode.ellipsis} '); // Make sure ellipses have a space after them, but only if they are followed by a letter and not at the start of the sentence.
    return ResultPair<Word, S, T>(Word(input), Word(cleanedString));
  }

  @override
  Iterable<Result<Atom<Sentence, X>, S, T>?> transliterateAtoms<X>(Iterable<Atom<StringUnit, X>?> unitAtoms) {
    final List<Atom<StringUnit, X>?> unitAtomsList = unitAtoms.toList();
    final int firstAtomIndex = unitAtomsList.indexWhere((Atom<StringUnit, X>? atom) => atom != null);
    final int lastAtomIndex = unitAtomsList.lastIndexWhere((Atom<StringUnit, X>? atom) => atom != null);
    if (firstAtomIndex >= 0 && lastAtomIndex >= 0) {
      // Remove periods and exclamation points from the end of the sentence. Note that this has to happen before adding new punctuation, otherwise the period we add to the start of a sentence might get replaced.
      Match? lastPeriodMatch;
      // Start at the last atom and look for a period. If you don't find one, look in the previous atom to see if it's there. Repeat until you find a period or you search back to the first atom.
      for (int lastPeriodAtomIndex = lastAtomIndex; lastPeriodAtomIndex >= firstAtomIndex && lastPeriodMatch == null; lastPeriodAtomIndex--) {
        final String lastPeriodAtomContent = unitAtomsList[lastPeriodAtomIndex]!.content.content;
        final Iterable<Match> lastPeriodMatches = closingPeriodPattern.allMatches(lastPeriodAtomContent);
        final Match? lastPeriodMatch = lastPeriodMatches.isNotEmpty ? lastPeriodMatches.last : null;

        // If this atom has any closing periods, remove the last one.
        if (lastPeriodMatch != null) {
          final Sentence lastPeriodAtomNewContent = Sentence(lastPeriodAtomContent.replaceRange(lastPeriodMatch.start, lastPeriodMatch.end, ''));
          unitAtomsList[lastPeriodAtomIndex] = unitAtomsList[lastPeriodAtomIndex]!.withNewContent(lastPeriodAtomNewContent);
          break;
        }
      }

      //TODO: Add logic here to check to see if the sentence has [a-zA-Z] characters in it. If not (such as in the case  of a "sentence" that consists of asterisks for a section break, process it via the special rules, otherwise add a period to the start and process as normal.

      // Add a period to the start of the sentence in the appropriate place
      if (!mode.treatAsFragment) {
        final String firstAtomText = unitAtomsList[firstAtomIndex]!.content.content;
        final Match? openingQuotes = openingQuotePattern.matchAsPrefix(firstAtomText);
        Sentence firstAtomNewContent;
        if (openingQuotes != null) {
          firstAtomNewContent =
              Sentence(firstAtomText.substring(openingQuotes.start, openingQuotes.end) + leadingPeriod + firstAtomText.substring(openingQuotes.end));
        } else {
          firstAtomNewContent = Sentence(leadingPeriod + firstAtomText);
        }
        unitAtomsList[firstAtomIndex] = unitAtomsList[firstAtomIndex]!.withNewContent(firstAtomNewContent);
      }
    }

    return super.transliterateAtoms(
        unitAtomsList.map((Atom<StringUnit, X>? atom) => atom?.withNewContent(Sentence(cleanNonWordCharacters(atom.content.content).target.content))).toList());
  }

  @override
  WordTransliterator<S, T> getSubtransliterator() => WordTransliterator.fromTransliterator(this);

  @override
  Sentence buildUnit(String string) => Sentence(string);
}
