import 'glyph.dart';
import 'script.dart';

enum AlethiGlyphShape { line, leftTriangle, rightTriangle, diamond, leftDoubleTriangle, none }

enum AlethiGlyphSize { three, two, one, oneTick, twoTicks, none }

class AlethiGlyph extends Glyph {
  final AlethiGlyphShape shape;
  final AlethiGlyphSize size;

  const AlethiGlyph(String stringValue, {this.shape = AlethiGlyphShape.none, this.size = AlethiGlyphSize.none}) : super(Script.alethi, stringValue);

  factory AlethiGlyph.fromString(String string) => stringMap[string] ?? AlethiGlyph(string);

  //<editor-fold desc="AlethiGlyph const definitions" default-state="collapsed">
  static const AlethiGlyph a = AlethiGlyph('a', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.two);
  static const AlethiGlyph b = AlethiGlyph('b', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.two);
  static const AlethiGlyph ch = AlethiGlyph('C', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.oneTick);
  static const AlethiGlyph d = AlethiGlyph('d', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.two);
  static const AlethiGlyph e = AlethiGlyph('e', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.three);
  static const AlethiGlyph f = AlethiGlyph('f', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.oneTick);
  static const AlethiGlyph g = AlethiGlyph('g', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.two);
  static const AlethiGlyph h = AlethiGlyph('h', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.twoTicks);
  static const AlethiGlyph i = AlethiGlyph('i', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.twoTicks);
  static const AlethiGlyph j = AlethiGlyph('j', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.twoTicks);
  static const AlethiGlyph k = AlethiGlyph('k', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.three);
  static const AlethiGlyph l = AlethiGlyph('l', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.twoTicks);
  static const AlethiGlyph m = AlethiGlyph('m', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.one);
  static const AlethiGlyph n = AlethiGlyph('n', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.one);
  static const AlethiGlyph o = AlethiGlyph('o', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.one);
  static const AlethiGlyph p = AlethiGlyph('p', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.three);
  static const AlethiGlyph r = AlethiGlyph('r', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.one);
  static const AlethiGlyph s = AlethiGlyph('s', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.three);
  static const AlethiGlyph sh = AlethiGlyph('>', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.oneTick);
  static const AlethiGlyph t = AlethiGlyph('t', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.three);
  static const AlethiGlyph th = AlethiGlyph('<', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.oneTick);
  static const AlethiGlyph u = AlethiGlyph('u', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.oneTick);
  static const AlethiGlyph v = AlethiGlyph('v', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.twoTicks);
  static const AlethiGlyph x = AlethiGlyph('x', size: AlethiGlyphSize.three);
  static const AlethiGlyph y = AlethiGlyph('y', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.one);
  static const AlethiGlyph z = AlethiGlyph('z', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.two);
  static const AlethiGlyph period = AlethiGlyph('.', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.three);
  static const AlethiGlyph empty = AlethiGlyph('');

  //</editor-fold>

  static const Map<String, AlethiGlyph> stringMap = <String, AlethiGlyph>{
    'a': a,
    'b': b,
    'c': ch,
    'd': d,
    'e': e,
    'f': f,
    'g': g,
    'h': h,
    'i': i,
    'j': j,
    'k': k,
    'l': l,
    'm': m,
    'n': n,
    'o': o,
    'p': p,
    'r': r,
    's': s,
    '>': sh,
    't': t,
    '<': th,
    'u': u,
    'v': v,
    'x': x,
    'y': y,
    'z': z,
    '.': period,
  };

  static const List<AlethiGlyph> alphabet = <AlethiGlyph>[a, b, ch, d, e, f, g, h, i, j, k, l, m, n, o, p, r, s, sh, t, th, u, v, x, y, z, period];

  static const Map<AlethiGlyph, AlethiGlyph> reflection = <AlethiGlyph, AlethiGlyph>{
    a: a,
    b: b,
    d: z,
    e: e,
    m: m,
    n: r,
    o: o,
    p: p,
    r: n,
    s: t,
    t: s,
    z: d,
    period: period
  };

  int get tickMarkCount {
    switch (size) {
      case AlethiGlyphSize.oneTick:
        return 2;
      case AlethiGlyphSize.twoTicks:
        return 1;
      case AlethiGlyphSize.three:
      case AlethiGlyphSize.two:
      case AlethiGlyphSize.one:
      case AlethiGlyphSize.none:
        return 0;
    }
  }

  int get height {
    switch (size) {
      case AlethiGlyphSize.three:
        return 3;
      case AlethiGlyphSize.two:
      case AlethiGlyphSize.oneTick:
        return 2;
      case AlethiGlyphSize.one:
      case AlethiGlyphSize.twoTicks:
        return 1;
      case AlethiGlyphSize.none:
        return 0;
    }
  }

  //Because they are all horizontally symmetric, any glyphs with vertical symmetry are also rotationally symmetric.
  static const Map<AlethiGlyph, AlethiGlyph> rotation = reflection;

  //FIXME: Figure out how to properly type these so they only accept AlethiGlyph arguments.
  @override
  bool isReflectionOf(Glyph other) => reflection[this] == other;

  @override
  bool isRotationOf(Glyph other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
