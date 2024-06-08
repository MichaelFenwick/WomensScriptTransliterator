import 'glyph.dart';
import 'script.dart';

enum AlethiGlyphShape { line, leftTriangle, rightTriangle, diamond, leftDoubleTriangle, none }

enum AlethiGlyphSize { three, two, one, oneTick, twoTicks, none }

class AlethiGlyph extends Glyph<Alethi> {
  final AlethiGlyphShape shape;
  final AlethiGlyphSize size;

  const AlethiGlyph(super.stringValue, {this.shape = AlethiGlyphShape.none, this.size = AlethiGlyphSize.none});

  static Glyph<Alethi> fromString(String string) => stringMap[string] ?? Glyph<Alethi>(string);

  //<editor-fold desc="AlethiGlyph const definitions" default-state="collapsed">
  static const Glyph<Alethi> a = AlethiGlyph('a', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.two);
  static const Glyph<Alethi> b = AlethiGlyph('b', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.two);
  static const Glyph<Alethi> ch = AlethiGlyph('C', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.oneTick);
  static const Glyph<Alethi> d = AlethiGlyph('d', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.two);
  static const Glyph<Alethi> e = AlethiGlyph('e', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.three);
  static const Glyph<Alethi> f = AlethiGlyph('f', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.oneTick);
  static const Glyph<Alethi> g = AlethiGlyph('g', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.two);
  static const Glyph<Alethi> h = AlethiGlyph('h', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.twoTicks);
  static const Glyph<Alethi> i = AlethiGlyph('i', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.twoTicks);
  static const Glyph<Alethi> j = AlethiGlyph('j', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.twoTicks);
  static const Glyph<Alethi> k = AlethiGlyph('k', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.three);
  static const Glyph<Alethi> l = AlethiGlyph('l', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.twoTicks);
  static const Glyph<Alethi> m = AlethiGlyph('m', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.one);
  static const Glyph<Alethi> n = AlethiGlyph('n', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.one);
  static const Glyph<Alethi> o = AlethiGlyph('o', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.one);
  static const Glyph<Alethi> p = AlethiGlyph('p', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.three);
  static const Glyph<Alethi> r = AlethiGlyph('r', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.one);
  static const Glyph<Alethi> s = AlethiGlyph('s', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.three);
  static const Glyph<Alethi> sh = AlethiGlyph('>', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.oneTick);
  static const Glyph<Alethi> t = AlethiGlyph('t', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.three);
  static const Glyph<Alethi> th = AlethiGlyph('<', shape: AlethiGlyphShape.leftTriangle, size: AlethiGlyphSize.oneTick);
  static const Glyph<Alethi> u = AlethiGlyph('u', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.oneTick);
  static const Glyph<Alethi> v = AlethiGlyph('v', shape: AlethiGlyphShape.diamond, size: AlethiGlyphSize.twoTicks);
  static const Glyph<Alethi> x = AlethiGlyph('x', size: AlethiGlyphSize.three);
  static const Glyph<Alethi> y = AlethiGlyph('y', shape: AlethiGlyphShape.leftDoubleTriangle, size: AlethiGlyphSize.one);
  static const Glyph<Alethi> z = AlethiGlyph('z', shape: AlethiGlyphShape.rightTriangle, size: AlethiGlyphSize.two);
  static const Glyph<Alethi> period = AlethiGlyph('.', shape: AlethiGlyphShape.line, size: AlethiGlyphSize.three);
  static const Glyph<Alethi> empty = AlethiGlyph('');

  //</editor-fold>

  static const Map<String, Glyph<Alethi>> stringMap = <String, Glyph<Alethi>>{
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

  static const List<Glyph<Alethi>> alphabet = <Glyph<Alethi>>[a, b, ch, d, e, f, g, h, i, j, k, l, m, n, o, p, r, s, sh, t, th, u, v, x, y, z, period];

  static const Map<Glyph<Alethi>, Glyph<Alethi>> reflection = <Glyph<Alethi>, Glyph<Alethi>>{
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
  static const Map<Glyph<Alethi>, Glyph<Alethi>> rotation = reflection;

  @override
  bool isReflectionOf(Glyph<Alethi> other) => reflection[this] == other;

  @override
  bool isRotationOf(Glyph<Alethi> other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
