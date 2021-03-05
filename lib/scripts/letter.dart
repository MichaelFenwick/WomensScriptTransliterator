import 'language.dart';

class Letter<L extends Language> {
  final String stringValue;
  final bool isGeneric;

  const Letter(this.stringValue, {this.isGeneric = true});

  static Letter<T> fromString<T extends Language>(String string) => Letter<T>(string);

  static Map<Letter<Language>, Letter<Language>> reflection = <Letter<Language>, Letter<Language>>{};
  static Map<Letter<Language>, Letter<Language>> rotation = <Letter<Language>, Letter<Language>>{};

  Letter<T> toLanguage<T extends Language>() => Letter<T>(stringValue);

  Type get language => L;

  bool isReflectionOf(Letter<L> other) => reflection[this] == other;
  bool isRotationOf(Letter<L> other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
