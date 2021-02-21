import 'language.dart';
import 'letters/alethi_letter.dart';
import 'letters/english_letter.dart';
import 'letters/letter.dart';

class Word<L extends Language> implements Comparable<Word<L>> {
  final List<Letter<L>> letters;

  const Word(this.letters);

  //TODO: This currently creates empty letters for characters not in the target language. This needs to be changed to create a special type of letter which is identifiable as empty (using a flag maybe?) but which persists the character's string representation.
  //TODO: Related to the above, I could really stand to have a special function to change the language of a letter without changing anything else (unless casting is all I need in the end?)
  Word.fromString(String string)
      : letters = string.toLowerCase().split('').map((String character) {
          switch (L) {
            case English:
              return (EnglishLetter.stringMap[character] ?? EnglishLetter.empty) as Letter<L>;
            case Alethi:
              return (AlethiLetter.stringMap[character] ?? AlethiLetter.empty) as Letter<L>;
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
