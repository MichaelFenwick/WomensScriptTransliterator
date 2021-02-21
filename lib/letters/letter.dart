import '../language.dart';

class Letter<L extends Language> {
  final String stringValue;

  const Letter(this.stringValue);

  Letter<T> toLanguage<T extends Language>() => Letter<T>(stringValue);

  Type get language => L;

  @override
  String toString() => stringValue;
}
