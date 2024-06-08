part of womens_script_transliterator;

class WordTransliterator<S extends Script, T extends Script> extends StringTransliterator<Word, S, T> {
  WordTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static WordTransliterator<S, T> fromTransliterator<S extends Script, T extends Script>(Transliterator<dynamic, S, T> transliterator) =>
      WordTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Result<Word, S, T> transliterate(Word input, {bool useOutputWriter = false}) {
    final Match? match = RegExp('^(.*?)([a-zA-Z0-9\'’-]+)(.*)\$').firstMatch(input.content);
    if (match == null) {
      return ResultPair<Word, S, T>.fromValue(input);
    }
    final ResultPair<Word, S, T> prewordResult = ResultPair<Word, S, T>.fromValue(Word(match.group(1)!));
    final Result<Word, S, T> wordResult = _transliterateWord(Word(match.group(2)!.toLowerCase()));
    final ResultPair<Word, S, T> postwordResult = ResultPair<Word, S, T>.fromValue(Word(match.group(3)!));
    final Result<Word, S, T> result =
        Result.join(<Result<Word, S, T>>[prewordResult, wordResult, postwordResult], sourceReducer: sourceReducer, targetReducer: targetReducer);
    if (useOutputWriter) {
      outputWriter.writeln(result);
    }
    return result;
  }

  @override
  Word buildUnit(String string) => Word(string);

  /// Computes the transliteration [Result] of the given [word] based on the options set in this [WordTransliterator]'s [Mode].
  Result<Word, S, T> _transliterateWord(Word word) {
    // All the transliteration logic assumes the word isn't an empty string, so bail at the start if it is.
    if (word.content.isEmpty) {
      return ResultPair<Word, S, T>.fromValue(word);
    }

    // Check to see if the word is in the current dictionary first, and if so, return that result.
    if (dictionary.entries[word.content] != null) {
      return ResultPair<Word, S, T>(word, Word(dictionary.entries[word.content]!));
    }

    // If it wasn't in the dictionary, check the algorithm.
    final Result<Word, S, T> algorithmResult;

    if (mode.algorithmBestOptionOnly) {
      // First see if we can avoid recursion because only the best choice was requested. Don't worry about updating the dictionary in this case, since we won't know if the best result was the only result or not.
      algorithmResult = getBestResult(word);
    } else {
      // Otherwise we'll need to get the full possibility set.
      algorithmResult = getFullResult(word);
      if (algorithmResult is ResultPair<Word, S, T>) {
        // If we're lucky and the transliteration is unambiguous, then we can update the dictionary with this result as well.
        dictionary.update(algorithmResult.cast<String>((Word word) => word.content) as ResultPair<String, S, T>);
      } else {
        // But if it's not unambiguous, then we'll need to log it so that it can be manually transliterated later.
        debugWriter.writeln(algorithmResult);
      }
    }

    return algorithmResult;
  }

  /// Get the most likely transliteration of an [input] word.
  ///
  /// This works by iterating through the [input] and using the first matching [Rule]'s first [OptionSet]'s first option, and then advancing a number of characters corresponding to the characters that option consumed. This means that calling this function on a string may give a result which is not a substring of calling this function on the same string after prepending it with additional characters. For example, for English to Alethi transliterations, `getBestResult('head')` will return a [ResultPair] with the target of `head`, while `getBestResult('hothead')` will return a [ResultPair] with the target of `ho>ead`.
  ResultPair<Word, S, T> getBestResult(Word input) {
    final StringBuffer transliteratedWord = StringBuffer();
    int cursor = 0;

    while (cursor < input.content.length) {
      final Iterable<OptionSet<S, T>> nextOptions = _getNextOptionSets(input.content, cursor);
      // When we just want the best result, we'll use the first option set from the rule's list of options.
      final OptionSet<S, T> nextOption = nextOptions.first;
      cursor += nextOption.source.length;
      transliteratedWord.write(nextOption.target.first);
    }

    return ResultPair<Word, S, T>(input, buildUnit(transliteratedWord.toString()));
  }

  /// Gets all the possible ways the [input] word might be transliterated.
  ///
  /// This only cares if a transliteration is possible, not if it is likely. If the [input] can be transliterated in multiple ways, the most likely transliteration will be the first element of the [ResultSet.target], but the remaining options will ordered arbitrarily.
  Result<Word, S, T> getFullResult(Word input) =>
      Result<Word, S, T>.fromIterable(input, _getSubwordTransliterations(input.content, _getOptionSetMapForString(input.content)).map(buildUnit));

  /// Returns all possible transliterations for a given [input].
  ///
  /// This uses the transliteration options available in the provided [optionsSetMap] to compute all the possible ways the [input] word might be transliterated. If a [cursor] value is supplied, then this will only return the ways that the substring from that [cursor] position to the [input] word's end can be transliterated. The possible transliterations are returned as a lazy Iterable of Strings.
  Iterable<String> _getSubwordTransliterations(String input, List<Iterable<OptionSet<S, T>>> optionsSetMap, [int cursor = 0]) =>
      optionsSetMap[cursor].map((OptionSet<S, T> optionSet) {
        // Check to see if this option set will bring the new cursor position to the end of the string.
        if (cursor + optionSet.source.length < input.length) {
          // If not, recurse to get the possible transliterations for the part of the string that remains after consuming this option set's `source` string.
          final Iterable<String> remainingSubwordTargets = _getSubwordTransliterations(input, optionsSetMap, cursor + optionSet.source.length);
          // And then add those recursed results to all of this option set's target strings
          return optionSet.target
              .expand((String optionsSetTarget) => remainingSubwordTargets.map((String remainingSubwordTarget) => optionsSetTarget + remainingSubwordTarget));
        } else {
          // Otherwise, we're at the end, so just return this option set's targets.
          return optionSet.target;
        }
      }).expand((Iterable<String> subwordTransliterations) => subwordTransliterations);

  /// Returns a List of all [OptionSet]s which can apply to the [input] at each index of the string. The [OptionSet]s at each index of the returned [List] correspond to the ones which are applicable to the [input] at that character position.
  List<Iterable<OptionSet<S, T>>> _getOptionSetMapForString(String input) =>
      List<Iterable<OptionSet<S, T>>>.generate(input.length, (int index) => _getNextOptionSets(input, index));

  /// For a given [cursor] position in the [inputString], gets all the possible ways the next letter(s) might be transliterated.
  Iterable<OptionSet<S, T>> _getNextOptionSets(String inputString, int cursor) {
    final Iterable<Rule<S, T>> matchingRules = RuleSet.getRuleSet<S, T>().where((Rule<S, T> rule) => rule.matches(inputString, cursor));

    if (matchingRules.isNotEmpty) {
      return matchingRules.expand<OptionSet<S, T>>((Rule<S, T> rule) => rule.options);
    }

    // if no rule matched, then transliterate the next character as being unchanged
    return <OptionSet<S, T>>[
      OptionSet<S, T>(inputString[cursor], <String>[inputString[cursor]])
    ];
  }
}
