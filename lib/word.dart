import 'language.dart';
import 'letters/alethi_letter.dart';
import 'letters/english_letter.dart';
import 'letters/letter.dart';

class Word<L extends Language> implements Comparable<Word<L>> {
  final List<Letter<L>> letters;

  const Word(this.letters);

  Word.fromString(String string)
      : letters = string.toLowerCase().split('').map((String character) {
          switch (L) {
            case English:
              return (EnglishLetter.stringMap[character] ?? Letter<L>(character)) as Letter<L>;
            case Alethi:
              return (AlethiLetter.stringMap[character] ?? Letter<L>(character)) as Letter<L>;
            default:
              throw TypeError();
          }
        }).toList();

  int get length => letters.length;

  Type get language => L;

  Letter<L> operator [](int index) => letters[index];

  Word<L> subWord(int start, [int? end]) => Word<L>(letters.sublist(start, end));

  @override
  String toString() => letters.join();

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => other is Word<L> && toString() == other.toString();

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => toString().hashCode;

  @override
  int compareTo(Word<L> other) {
    if (other is! Word<L>) {
      throw TypeError();
    }
    return toString().compareTo(other.toString());
  }
}
