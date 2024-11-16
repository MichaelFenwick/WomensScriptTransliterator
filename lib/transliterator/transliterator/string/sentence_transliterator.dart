part of womens_script_transliterator;

class SentenceTransliterator<S extends Script, T extends Script> extends StringTransliterator<Sentence, S, T>
    with SuperUnitStringTransliterator<Sentence, S, T> {
  SentenceTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static SentenceTransliterator<S, T> fromTransliterator<S extends Script, T extends Script>(Transliterator<dynamic, S, T> transliterator) =>
      SentenceTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  //FIXME: This isn't actually being called when transliterating an epub, since it all goes through transliterateAtoms instead. Merge this method and that one.
  @override
  Result<Sentence, S, T> transliterate(Sentence input, {bool useOutputWriter = false}) {
    final Result<Sentence, S, T> finalResult;
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
        ? ResultPair<Sentence, S, T>.fromValue(Sentence(''))
        : ResultPair<Sentence, S, T>(Sentence(openingPunctuation ?? ''), Sentence(newOpeningPunctuation));
    final Result<Sentence, S, T> closingPunctuationResult = closingPunctuation != null
        ? ResultPair<Sentence, S, T>(Sentence(closingPunctuation), Sentence(closingPunctuation.replaceFirst(RegExp('[!.]+'), '')))
        : ResultPair<Sentence, S, T>.fromValue(Sentence(''));

    finalResult = Result.join<Sentence, S, T>(<Result<Sentence, S, T>>[openingPunctuationResult, wordResult, closingPunctuationResult],
        sourceReducer: sourceReducer, targetReducer: targetReducer);

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

  //TODO: I have to do some cleaning in the XML Translator as well, currently. I need to find a way to do both this and that cleaning in the same place.
  ResultPair<Word, S, T> cleanNonWordCharacters(String input) {
    final String cleanedString = input
        // Make sure em dashes have spaces surrounding them if they're attached to words on both sides (otherwise the two words will look like a single hyphenated word).
        .replaceAllMapped(RegExp('(\\w)${Unicode.emDash}(\\w)'), (Match m) => '${m[1]} ${Unicode.emDash} ${m[2]}')
        //TODO: These regex are complex and hard to read. While they're working as expected (unless an ellipsis is on the boundary of an  [as happens when the first or lost word of a sentence is italicized], in which case the regex can't see what is on the neighboring Atom - but that's a much harder problem that's probably not worth trying to solve), code maintenance on this is probably suck. This might be better rewritten as something that captures the ellipsis and surrounding characters, and then replaces it based on if statements or switches. This could allow for things like `if (attachedWordOnLeft && !punctuationOnRight) {[...]}`.
        //FIXME: The following logic will convert `but … ‘hilarious’` into but⁠…⁠‘hilarious’`, as a result of the word following the ellipsis being quoted. It needs to be tweaked to ensure that the ellipsis only attaches to the first word in this case. Probably just need to change the rule that removes a space between ellipses and following punctuation to only trigger if that punctuation (or consecutive punctuations) are followed by a `\s` or end of string.
        // Make sure ellipses have a space after them, but only if they are followed by a letter and not at the start of the sentence.
        .replaceAll(RegExp(r'(?<!^[.\s]*)…(?=[a-zA-Z])'), '… ')
        // If an ellipsis is not attached to a word on either side, but is preceded by a word and space, attach it to that word.
        .replaceAll(RegExp(r'(?<=\w)[\s ⁠]…(?!⁠?\w)'), '⁠…')
        // Also check for ellipses which aren't attached to words on either side, but which have a space and word following them, and attach them to that following word.
        .replaceAll(RegExp(r'(?<!\w⁠?)…[\s ⁠](?=\w)'), '…⁠')
        // Ellipses frequently have spaces between them and adjacent punctuation, but it looks better to them connected. Remove any space characters between ellipses and preceding punctuation.
        .replaceAll(RegExp(r'(?<=[^\w\d\s]\s)…'), '⁠…')
        // Also remove spaces between ellipses and following punctuation.
        .replaceAll(RegExp(r'…\s(?=[^\w\d\s])'), '…⁠');

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
      // FIXME: lastPeriodMatch doesn't seem to be being used. It was probably used at some point in the past, but is no longer needed. I should look through the git history to see if I can figure out what's going on here.
      // FIXME: It looks like the act of moving the period to the start of a sentence is being done on BOTH the result source and target. The result source _should_ remain unchanged from the original text, while only the target is changed. This isn't a particularly problematic bug in that it only really affects debugging output, but it should still be remedied to prevent any future problems and to keep things consistent.
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
