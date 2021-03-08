part of transliterator;

class WordTransliterator<S extends Language, T extends Language> extends StringTransliterator<S, T> {
  List<ResultSet<String, S, T>> optionsMap = <ResultSet<String, S, T>>[];

  WordTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static WordTransliterator<S, T> fromTransliterator<E, S extends Language, T extends Language>(Transliterator<E, S, T> transliterator) =>
      WordTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Result<String, S, T> transliterate(String input, {bool useOutputWriter = false}) {
    //TODO: More robust letter case logic should be added. Maybe the toLowerCase could be used for the transliteration, and then we can look at the casing of the input (maybe upperFirst, allLower, and allUpper as options?) to convert the transliterated output to match.
    final Result<String, S, T> result = _transliterateWord(input.toLowerCase());
    if (useOutputWriter) {
      outputWriter.writeln(result);
    }
    return result;
  }

  /// Computes the transliteration for this WordTransliterator's word based on the options set in the Transliterator's Mode.
  Result<String, S, T> _transliterateWord(String word) {
    // All the transliteration logic assumes the word isn't an empty string, so bail at the start if it is.
    if (word.isEmpty) {
      return ResultPair<String, S, T>.fromValue(word);
    }

    // Check to see if the word is in the current dictionary first, and if so, return that result.
    if (dictionary.entries[word] != null) {
      return ResultPair<String, S, T>(word, dictionary.entries[word] as String);
    }

    // If it wasn't in the dictionary, check the algorithm.
    final Result<String, S, T> algorithmResult;

    if (mode.algorithmBestOptionOnly) {
      // First see if we can avoid recursion because only the best choice was requested. Don't worry about updating the dictionary in this case, since we won't know if the best result was the only result or not.
      algorithmResult = getBestResult(word);
    } else {
      // Otherwise we'll need to get the full possibility set.
      algorithmResult = getFullResult(word);
      if (algorithmResult is ResultPair<String, S, T>) {
        // If we're lucky and the transliteration is unambiguous, then we can update the dictionary with this result as well.
        dictionary.update(algorithmResult);
      } else {
        // But if it's not unambiguous, then we'll need to log it so that it can be manually transliterated later.
        debugWriter.writeln(algorithmResult);
      }
    }

    return algorithmResult;
  }

  /// Get the most likely transliteration of a word by iterating through it and using the first returned TransliterationOption at each cursor position.
  ResultPair<String, S, T> getBestResult(String input) {
    final StringBuffer transliteratedWord = StringBuffer();
    int cursor = 0;

    while (cursor < input.length) {
      final ResultSet<String, S, T> nextOption = _getNextOptionSet(input, cursor);
      cursor += nextOption.source.length;
      transliteratedWord.write(nextOption.target.first);
    }

    return ResultPair<String, S, T>(input, transliteratedWord.toString());
  }

  /// Gets all the possible ways a word might be transliterated. This only cares if a transliteration is possible, not if it is likely.
  Result<String, S, T> getFullResult(String input) {
    optionsMap = List<ResultSet<String, S, T>>.generate(input.length, (int index) => _getNextOptionSet(input, index));
    return Result<String, S, T>.fromIterable(input, _getSubwordTransliterations(input));
  }

  /// Recursively gets all the possible ways the remainder of a word, from the cursor position onward, might be transliterated.
  List<String> _getSubwordTransliterations(String input, [int cursor = 0]) {
    final List<String> subwordTransliterationStrings = <String>[];

    for (final String target in optionsMap[cursor].target) {
      //check to see if thisOption was the end of the string. If so, recurse, otherwise just return these characters
      if (cursor + optionsMap[cursor].source.length < input.length) {
        final List<String> remainingSubwordTransliterationStrings = _getSubwordTransliterations(input, cursor + optionsMap[cursor].source.length);
        subwordTransliterationStrings.addAll(
            remainingSubwordTransliterationStrings.map((String remainingSubwordTransliterationString) => target + remainingSubwordTransliterationString));
      } else {
        subwordTransliterationStrings.add(target);
      }
    }

    return subwordTransliterationStrings;
  }

  /// For a given cursor position in a word, gets all the possible ways the next letter(s) might be transliterated.
  ResultSet<String, S, T> _getNextOptionSet(String inputString, int cursor) {
    final String cursorPrefix = inputString.substring(0, cursor);
    final String cursorPostfix = inputString.substring(cursor, inputString.length);

    for (final Rule<S, T> rule in RuleSet.getRuleSet<S, T>()) {
      if (rule.matches(cursorPrefix, cursorPostfix)) {
        return rule.options;
      }
    }

    // if no rule matched, then transliterate the next character as being unchanged
    return ResultSet<String, S, T>(cursorPostfix[0], LinkedHashSet<String>.of(<String>[cursorPostfix[0]]));
  }
}
