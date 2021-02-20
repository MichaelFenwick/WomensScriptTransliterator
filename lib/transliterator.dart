import 'digraphs/digraph.dart';
import 'language.dart';
import 'letters/letter.dart';
import 'substitutions.dart';
import 'word.dart';

class Transliterator {
  static List<Word<T>> transliterateWord<S extends Language, T extends Language>(Word<S> input) => _transliterateSubword<S, T>(input).toSet().toList()..sort();

  static List<Word<T>> _transliterateSubword<S extends Language, T extends Language>(Word<S> input) {
    if (input.length == 0) {
      return <Word<T>>[];
    }

    // get options for the next letter by itself.
    final List<Word<T>> nonDigraphTransliterations = _getPartialTransliterationList<S, T>(input[0], input.subWord(1));

    List<Word<T>> digraphTransliterations = <Word<T>>[];

    // also figure out if we need to return options for a potential digraph. This can only be the case if we have at least two letters remaining which are both of the source language.
    if (input.length > 1 && input[0].language == S && input[1].language == S) {
      final String firstTwoLetters = input[0].stringValue + input[1].stringValue;
      final Digraph<S> digraph = Digraph.getDigraphFromString<S>(firstTwoLetters);

      // if it's a valid input digraph, we'll process it as such
      if (Digraph.getInputDigraphs<S>().contains(digraph)) {
        digraphTransliterations = _getPartialTransliterationList<S, T>(digraph, input.subWord(2));
      }
    }

    return nonDigraphTransliterations + digraphTransliterations;
  }

  static List<Word<T>> _getPartialTransliterationList<S extends Language, T extends Language>(Letter<S> currentGrapheme, Word<S> remainingLetters) {
    List<Letter<T>> currentGraphemeOptions;
    final List<Word<T>> transliterations = <Word<T>>[];

    currentGraphemeOptions = Substitutions.getSubstitutions<S, T>(currentGrapheme);

    // if there aren't anymore letters to go, then we'll just use the current options as the "words" for the list of potential transliterations. First, we need to wrap each option in an array though, so they look like Words and not letters.
    if (remainingLetters.length == 0) {
      transliterations.addAll(currentGraphemeOptions.map((Letter<T> option) => Word<T>(<Letter<T>>[option])));
    } else {
      // if there are more letters recurse
      final List<Word<T>> remainingLettersOptions = _transliterateSubword<S, T>(remainingLetters);
      for (final Letter<T> currentGraphemeOption in currentGraphemeOptions) {
        for (final Word<T> remainingLettersOption in remainingLettersOptions) {
          transliterations.add(Word<T>(<Letter<T>>[currentGraphemeOption, ...remainingLettersOption.letters]));
        }
      }
    }
    return transliterations;
  }
}
