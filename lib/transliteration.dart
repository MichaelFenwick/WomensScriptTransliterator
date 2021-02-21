import 'language.dart';
import 'word.dart';

class Transliteration<S extends Language, T extends Language> {
  final Word<S> sourceWord;
  final List<Word<T>> potentialTransliterations;
  String get sourceWordString => sourceWord.toString();
  String get firstTransliterationString => potentialTransliterations[0].toString();

  const Transliteration(this.sourceWord, this.potentialTransliterations);

  const Transliteration.empty(this.sourceWord) : potentialTransliterations = const <dynamic>[] as List<Word<T>>;

  //TODO: Have this return a winnowed list once I write the function that does the winnowing.
  Transliteration<S, T> getBestTransliteration() => Transliteration<S, T>(sourceWord, potentialTransliterations);

  @override
  String toString() => '[$sourceWord => ${potentialTransliterations.join(',')}]';
}
