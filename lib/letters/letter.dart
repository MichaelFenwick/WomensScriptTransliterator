import '../language.dart';

abstract class Letter<L extends Language> {
  final String stringValue;

  const Letter(this.stringValue);

  Type get language => L;

  @override
  String toString() => stringValue;
}
