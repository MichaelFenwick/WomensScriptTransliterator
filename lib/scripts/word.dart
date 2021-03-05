import 'alethi_letter.dart';
import 'english_letter.dart';
import 'language.dart';
import 'letter.dart';

class Word<L extends Language> implements Comparable<Word<L>> {
  final List<Letter<L>> letters;

  const Word(this.letters);

  //FIXME: This doesn't work for converting a WS string into a Word<Alethi> because it'll .toLowerCase() any `C` letters, which prevents them from becoming AlethiLetter.ch letters. Alternatively, just allow lowercase `c` to be used as the identifier for AlethiLetter.ch.
  Word.fromString(String string)
      : letters = string.toLowerCase().split('').map((String character) {
          switch (L) {
            case English:
              return EnglishLetter.fromString(character) as Letter<L>;
            case Alethi:
              return AlethiLetter.fromString(character) as Letter<L>;
            default:
              throw TypeError();
          }
        }).toList();

  int get length => letters.length;

  Type get language => L;

  Letter<L> operator [](int index) => letters[index];

  Word<L> subWord(int start, [int? end]) => Word<L>(letters.sublist(start, end));

  //TODO: Add fun things like methods to see if a word is reflectable/rotatable and methods to get the reflection/rotation of this word.

  @override
  String toString() => letters.join();

  @override
  bool operator ==(Object other) => other is Word<L> && toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  int compareTo(Word<L> other) {
    if (other is! Word<L>) {
      throw TypeError();
    }
    return toString().compareTo(other.toString());
  }
}
