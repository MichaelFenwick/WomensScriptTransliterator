import 'dictionary.dart';
import 'digraphs/digraph.dart';
import 'language.dart';
import 'letters/letter.dart';
import 'substitutions.dart';
import 'transliteration.dart';
import 'word.dart';

class Transliterator<S extends Language, T extends Language> {
  final TransliteratorMode mode;
  final Dictionary<S, T>? dictionary;

  Transliterator({this.mode = const TransliteratorMode(), this.dictionary})
      : assert(dictionary != null || mode.useDictionary == false, 'A dictionary must be supplied when using `TranslatorMode.useDictionary = true`.');

  Transliteration<S, T> transliterateWord(Word<S> input) {
    Transliteration<S, T> transliteration;
    if (mode.useDictionary) {
      final String? dictionaryLookupResult = dictionary?.entries[input.toString()];

      if (dictionaryLookupResult != null) {
        return Transliteration<S, T>(input, <Word<T>>[Word<T>.fromString(dictionaryLookupResult)]);
      }

      // We always want to return something if we can, so if we didn't find a dictionary match, then run the algorithm to see if the answer is unambiguous
      transliteration = Transliteration<S, T>(input, _transliterateSubword(input).toSet().toList()..sort());

      // If we're lucky and the transliteration is unambiguous, the we'll return it no matter what mode options were chosen.
      if (transliteration.potentialTransliterations.length == 1) {
        dictionary?.update(transliteration);
        return transliteration;
      }

      //TODO: write this to a file instead of the console
      //log missing dictionary entry with potential transliterations to be manually transliterated and added to the dictionary later.
      // print(transliteration);

      //The combination of requesting to use the dictionary while not wanting to fallback to the algorithm is the only time we'll return an empty result.
      if (!mode.algorithmFallback) {
        return Transliteration<S, T>.empty(input);
      }
    } else {
      // If we didn't find the word in the dictionary, or didn't bother to look, then we'll need to check with the algorithm.
      transliteration = Transliteration<S, T>(
          input, _transliterateSubword(input).toSet().toList()..sort()); //get transliterations if we didn't already during the dictionary check
    }

    if (mode.algorithmBestOptionOnly) {
      return transliteration.getBestTransliteration();
    }
    return transliteration;
  }

  List<Word<T>> _transliterateSubword(Word<S> input) {
    if (input.length == 0) {
      return <Word<T>>[];
    }

    // get options for the next letter by itself.
    final List<Word<T>> nonDigraphTransliterations = _getPartialTransliterationList(input[0], input.subWord(1));

    List<Word<T>> digraphTransliterations = <Word<T>>[];

    // also figure out if we need to return options for a potential digraph. This can only be the case if we have at least two letters remaining.
    if (input.length > 1) {
      final String firstTwoLetters = input[0].stringValue + input[1].stringValue;
      final Digraph<S> digraph = Digraph.getDigraphFromString<S>(firstTwoLetters);

      // if it's a valid input digraph, we'll process it as such
      if (Digraph.getInputDigraphs<S>().contains(digraph)) {
        digraphTransliterations = _getPartialTransliterationList(digraph, input.subWord(2));
      }
    }

    return nonDigraphTransliterations + digraphTransliterations;
  }

  List<Word<T>> _getPartialTransliterationList(Letter<S> currentGrapheme, Word<S> remainingLetters) {
    List<Letter<T>> currentGraphemeOptions;
    final List<Word<T>> transliterations = <Word<T>>[];

    if (currentGrapheme.stringValue == '') {
      //if the currentGrapheme didn't exist in the source language (and was resolved to an empty letter) then transliterate it as another empty letter in the target language.
      currentGraphemeOptions = <Letter<T>>[Letter<T>('')];
    } else {
      //otherwise transliterate it normally
      currentGraphemeOptions = Substitutions.getSubstitutions<S, T>(currentGrapheme);
    }

    // if there aren't any more letters to go, then we'll just use the current options as the "words" for the list of potential transliterations. First, we need to wrap each option in an array though, so they look like Words and not letters.
    if (remainingLetters.length == 0) {
      transliterations.addAll(currentGraphemeOptions.map((Letter<T> option) => Word<T>(<Letter<T>>[option])));
    } else {
      // if there are more letters recurse
      final List<Word<T>> remainingLettersOptions = _transliterateSubword(remainingLetters);
      for (final Letter<T> currentGraphemeOption in currentGraphemeOptions) {
        for (final Word<T> remainingLettersOption in remainingLettersOptions) {
          transliterations.add(Word<T>(<Letter<T>>[currentGraphemeOption, ...remainingLettersOption.letters]));
        }
      }
    }
    return transliterations;
  }
}

class TransliteratorMode {
  final bool useDictionary;
  final bool algorithmFallback;
  final bool algorithmBestOptionOnly;

  const TransliteratorMode({this.useDictionary = true, this.algorithmFallback = true, this.algorithmBestOptionOnly = true});
}
