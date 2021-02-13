import 'package:womens_script_transliterator/word.dart';

import 'digraphs/digraph.dart';
import 'language.dart';
import 'letters/letter.dart';
import 'substitutions.dart';

class Transliterator {
  static List<Word> transliterateWord<S extends Language, T extends Language>(Word input) {
    //Deduplicate and sort the transliterations before returning them.
    var finalTransliterations = _transliterateSubword<S, T>(input).toSet().toList();
    finalTransliterations.sort();

    return finalTransliterations;
  }

  static List<Word> _transliterateSubword<S extends Language, T extends Language>(Word input) {
    if (input.isEmpty) {
      return [];
    }

    // get options for the next letter by itself.
    var nonDigraphTransliterations = _getPartialTransliterationList<S, T>(input[0], input.sublist(1));

    var digraphTransliterations = <Word>[];

    // also figure out if we need to return options for a potential digraph. This can only be the case if we have at least two letters remaining which are both of the source language.
    if (input.length > 1 && input[0].language == S && input[1].language == S) {
      var firstTwoLetters = input[0].stringValue + input[1].stringValue;
      var digraph = Digraph.getDigraphFromString<S>(firstTwoLetters);

      // if it's a valid input digraph, we'll process it as such
      if (digraph != null && Digraph.getInputDigraphs<S>().contains(digraph)) {
        digraphTransliterations = _getPartialTransliterationList<S, T>(digraph, input.sublist(2));
      }
    }

    return (nonDigraphTransliterations + digraphTransliterations);
  }

  static List<Word> _getPartialTransliterationList<S extends Language, T extends Language>(Letter currentGrapheme, Word remainingLetters) {
    List<Letter> currentGraphemeOptions;
    var transliterations = <Word>[];

    currentGraphemeOptions = Substitutions.getSubstitutions<S, T>(currentGrapheme);

    // if there aren't anymore letters to go, then we'll just use the current options as the "words" for the list of potential transliterations. First, we need to wrap each option in an array though, so they look like Words and not letters.
    if (remainingLetters.isEmpty) {
      transliterations.addAll(currentGraphemeOptions.map((option) => Word([option])));
    } else {
      // if there are more letters recurse
      var remainingLettersOptions = _transliterateSubword<S, T>(remainingLetters);
      currentGraphemeOptions.forEach((currentGraphemeOption) {
        remainingLettersOptions.forEach((remainingLettersOption) {
          transliterations.add(Word([currentGraphemeOption, ...remainingLettersOption]));
        });
      });
    }
    return transliterations;
  }
}
