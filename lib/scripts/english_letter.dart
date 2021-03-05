import 'language.dart';
import 'letter.dart';

class EnglishLetter extends Letter<English> {
  const EnglishLetter(String stringValue) : super(stringValue);

  static Letter<English> fromString(String string) => stringMap[string] ?? Letter<English>(string);

  //<editor-fold desc="EnglishLetter const definitions" default-state="collapsed">
  static const Letter<English> a = EnglishLetter('a');
  static const Letter<English> b = EnglishLetter('b');
  static const Letter<English> c = EnglishLetter('c');
  static const Letter<English> d = EnglishLetter('d');
  static const Letter<English> e = EnglishLetter('e');
  static const Letter<English> f = EnglishLetter('f');
  static const Letter<English> g = EnglishLetter('g');
  static const Letter<English> h = EnglishLetter('h');
  static const Letter<English> i = EnglishLetter('i');
  static const Letter<English> j = EnglishLetter('j');
  static const Letter<English> k = EnglishLetter('k');
  static const Letter<English> l = EnglishLetter('l');
  static const Letter<English> m = EnglishLetter('m');
  static const Letter<English> n = EnglishLetter('n');
  static const Letter<English> o = EnglishLetter('o');
  static const Letter<English> p = EnglishLetter('p');
  static const Letter<English> q = EnglishLetter('q');
  static const Letter<English> r = EnglishLetter('r');
  static const Letter<English> s = EnglishLetter('s');
  static const Letter<English> t = EnglishLetter('t');
  static const Letter<English> u = EnglishLetter('u');
  static const Letter<English> v = EnglishLetter('v');
  static const Letter<English> w = EnglishLetter('w');
  static const Letter<English> x = EnglishLetter('x');
  static const Letter<English> y = EnglishLetter('y');
  static const Letter<English> z = EnglishLetter('z');
  static const Letter<English> period = EnglishLetter('.');
  static const Letter<English> empty = EnglishLetter('');

  //</editor-fold>

  static const Map<String, Letter<English>> stringMap = <String, Letter<English>>{
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

  static const List<Letter<English>> alphabet = <Letter<English>>[a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, period];

  static const Map<Letter<English>, Letter<English>> reflection = <Letter<English>, Letter<English>>{
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

  static const Map<Letter<English>, Letter<English>> rotation = <Letter<English>, Letter<English>>{b: q, d: p, l: l, o: o, p: d, q: b, s: s, x: x, z: z};

  @override
  bool isReflectionOf(Letter<English> other) => reflection[this] == other;

  @override
  bool isRotationOf(Letter<English> other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
