import 'glyph.dart';
import 'script.dart';

class EnglishGlyph extends Glyph {
  const EnglishGlyph(String stringValue) : super(Script.english, stringValue);

  factory EnglishGlyph.fromString(String string) => stringMap[string] ?? EnglishGlyph(string);

  //<editor-fold desc="EnglishGlyph const definitions" default-state="collapsed">
  static const EnglishGlyph a = EnglishGlyph('a');
  static const EnglishGlyph b = EnglishGlyph('b');
  static const EnglishGlyph c = EnglishGlyph('c');
  static const EnglishGlyph d = EnglishGlyph('d');
  static const EnglishGlyph e = EnglishGlyph('e');
  static const EnglishGlyph f = EnglishGlyph('f');
  static const EnglishGlyph g = EnglishGlyph('g');
  static const EnglishGlyph h = EnglishGlyph('h');
  static const EnglishGlyph i = EnglishGlyph('i');
  static const EnglishGlyph j = EnglishGlyph('j');
  static const EnglishGlyph k = EnglishGlyph('k');
  static const EnglishGlyph l = EnglishGlyph('l');
  static const EnglishGlyph m = EnglishGlyph('m');
  static const EnglishGlyph n = EnglishGlyph('n');
  static const EnglishGlyph o = EnglishGlyph('o');
  static const EnglishGlyph p = EnglishGlyph('p');
  static const EnglishGlyph q = EnglishGlyph('q');
  static const EnglishGlyph r = EnglishGlyph('r');
  static const EnglishGlyph s = EnglishGlyph('s');
  static const EnglishGlyph t = EnglishGlyph('t');
  static const EnglishGlyph u = EnglishGlyph('u');
  static const EnglishGlyph v = EnglishGlyph('v');
  static const EnglishGlyph w = EnglishGlyph('w');
  static const EnglishGlyph x = EnglishGlyph('x');
  static const EnglishGlyph y = EnglishGlyph('y');
  static const EnglishGlyph z = EnglishGlyph('z');
  static const EnglishGlyph period = EnglishGlyph('.');
  static const EnglishGlyph empty = EnglishGlyph('');

  //</editor-fold>

  static const Map<String, EnglishGlyph> stringMap = <String, EnglishGlyph>{
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

  static const List<EnglishGlyph> alphabet = <EnglishGlyph>[a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, period];

  static const Map<EnglishGlyph, EnglishGlyph> reflection = <EnglishGlyph, EnglishGlyph>{
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

  static const Map<EnglishGlyph, EnglishGlyph> rotation = <EnglishGlyph, EnglishGlyph>{b: q, d: p, l: l, o: o, p: d, q: b, s: s, x: x, z: z};

  //FIXME: Figure out how to properly type these so they only accept EnglishGlyph arguments.
  @override
  bool isReflectionOf(Glyph other) => reflection[this] == other;

  @override
  bool isRotationOf(Glyph other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
