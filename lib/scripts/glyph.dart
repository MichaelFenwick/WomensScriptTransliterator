import 'script.dart';

class Glyph<L extends Script> {
  final String stringValue;

  const Glyph(this.stringValue);

  static Glyph<T> fromString<T extends Script>(String string) => Glyph<T>(string);

  static Map<Glyph<Script>, Glyph<Script>> reflection = <Glyph<Script>, Glyph<Script>>{};
  static Map<Glyph<Script>, Glyph<Script>> rotation = <Glyph<Script>, Glyph<Script>>{};

  Glyph<T> toScript<T extends Script>() => Glyph<T>(stringValue);

  Type get script => L;

  bool isReflectionOf(Glyph<L> other) => reflection[this] == other;

  bool isRotationOf(Glyph<L> other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
