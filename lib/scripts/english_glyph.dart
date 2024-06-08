import 'glyph.dart';
import 'script.dart';

class EnglishGlyph extends Glyph<English> {
  const EnglishGlyph(super.stringValue);

  static Glyph<English> fromString(String string) => stringMap[string] ?? Glyph<English>(string);

  //<editor-fold desc="EnglishGlyph const definitions" default-state="collapsed">
  static const Glyph<English> a = EnglishGlyph('a');
  static const Glyph<English> b = EnglishGlyph('b');
  static const Glyph<English> c = EnglishGlyph('c');
  static const Glyph<English> d = EnglishGlyph('d');
  static const Glyph<English> e = EnglishGlyph('e');
  static const Glyph<English> f = EnglishGlyph('f');
  static const Glyph<English> g = EnglishGlyph('g');
  static const Glyph<English> h = EnglishGlyph('h');
  static const Glyph<English> i = EnglishGlyph('i');
  static const Glyph<English> j = EnglishGlyph('j');
  static const Glyph<English> k = EnglishGlyph('k');
  static const Glyph<English> l = EnglishGlyph('l');
  static const Glyph<English> m = EnglishGlyph('m');
  static const Glyph<English> n = EnglishGlyph('n');
  static const Glyph<English> o = EnglishGlyph('o');
  static const Glyph<English> p = EnglishGlyph('p');
  static const Glyph<English> q = EnglishGlyph('q');
  static const Glyph<English> r = EnglishGlyph('r');
  static const Glyph<English> s = EnglishGlyph('s');
  static const Glyph<English> t = EnglishGlyph('t');
  static const Glyph<English> u = EnglishGlyph('u');
  static const Glyph<English> v = EnglishGlyph('v');
  static const Glyph<English> w = EnglishGlyph('w');
  static const Glyph<English> x = EnglishGlyph('x');
  static const Glyph<English> y = EnglishGlyph('y');
  static const Glyph<English> z = EnglishGlyph('z');
  static const Glyph<English> period = EnglishGlyph('.');
  static const Glyph<English> empty = EnglishGlyph('');

  //</editor-fold>

  static const Map<String, Glyph<English>> stringMap = <String, Glyph<English>>{
    'a': a,
    'b': b,
    'c': c,
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
    'q': q,
    'r': r,
    's': s,
    't': t,
    'u': u,
    'v': v,
    'w': w,
    'x': x,
    'y': y,
    'z': z,
    '!': period
  };

  static const List<Glyph<English>> alphabet = <Glyph<English>>[a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, period];

  static const Map<Glyph<English>, Glyph<English>> reflection = <Glyph<English>, Glyph<English>>{
    b: d,
    d: b,
    i: i,
    l: l,
    m: m,
    n: n,
    o: o,
    p: q,
    q: p,
    t: t,
    u: u,
    v: v,
    w: w,
    x: x,
    period: period
  };

  static const Map<Glyph<English>, Glyph<English>> rotation = <Glyph<English>, Glyph<English>>{b: q, d: p, l: l, o: o, p: d, q: b, s: s, x: x, z: z};

  @override
  bool isReflectionOf(Glyph<English> other) => reflection[this] == other;

  @override
  bool isRotationOf(Glyph<English> other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
