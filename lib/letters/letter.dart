import '../language.dart';
import 'alethi_letter.dart';
import 'english_letter.dart';
import 'meta_letter.dart';

abstract class Letter<T extends Language> {
  final String stringValue;

  const Letter(this.stringValue);

  static List<Letter> string2Letters<T>(String input) {
    switch (T) {
      case English:
        return input.toLowerCase().split('').map<Letter>((String character) {
          var englishLetter = EnglishLetter.stringMap[character];
          if (englishLetter != null) {
            return englishLetter;
          } else {
            return MetaLetter(character);
          }
        }).toList();
      case Alethi:
        return input.split('').map<Letter>((String character) {
          var alethiLetter = AlethiLetter.stringMap[character];
          if (alethiLetter != null) {
            return alethiLetter;
          } else {
            return MetaLetter(character);
          }
        }).toList();
      default:
        throw TypeError;
    }
  }

  Type get language => T;

  @override
  String toString() => stringValue;
}
