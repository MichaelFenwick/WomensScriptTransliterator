import 'script.dart';

abstract class Glyph {
  final String stringValue;

  final Script _script;

  const Glyph(this._script, this.stringValue);

  static Map<Glyph, Glyph> reflection = <Glyph, Glyph>{};
  static Map<Glyph, Glyph> rotation = <Glyph, Glyph>{};

  Script get script => _script;

  bool isReflectionOf(Glyph other) => reflection[this] == other;

  bool isRotationOf(Glyph other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
