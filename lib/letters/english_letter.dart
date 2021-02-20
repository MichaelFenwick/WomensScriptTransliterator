import '../language.dart';
import 'letter.dart';

class EnglishLetter extends Letter<English> {
  const EnglishLetter(String stringValue) : super(stringValue);

  //<editor-fold desc="EnglishLetter const definitions" default-state="collapsed">
  static const EnglishLetter a = EnglishLetter('a');
  static const EnglishLetter b = EnglishLetter('b');
  static const EnglishLetter c = EnglishLetter('c');
  static const EnglishLetter d = EnglishLetter('d');
  static const EnglishLetter e = EnglishLetter('e');
  static const EnglishLetter f = EnglishLetter('f');
  static const EnglishLetter g = EnglishLetter('g');
  static const EnglishLetter h = EnglishLetter('h');
  static const EnglishLetter i = EnglishLetter('i');
  static const EnglishLetter j = EnglishLetter('j');
  static const EnglishLetter k = EnglishLetter('k');
  static const EnglishLetter l = EnglishLetter('l');
  static const EnglishLetter m = EnglishLetter('m');
  static const EnglishLetter n = EnglishLetter('n');
  static const EnglishLetter o = EnglishLetter('o');
  static const EnglishLetter p = EnglishLetter('p');
  static const EnglishLetter q = EnglishLetter('q');
  static const EnglishLetter r = EnglishLetter('r');
  static const EnglishLetter s = EnglishLetter('s');
  static const EnglishLetter t = EnglishLetter('t');
  static const EnglishLetter u = EnglishLetter('u');
  static const EnglishLetter v = EnglishLetter('v');
  static const EnglishLetter w = EnglishLetter('w');
  static const EnglishLetter x = EnglishLetter('x');
  static const EnglishLetter y = EnglishLetter('y');
  static const EnglishLetter z = EnglishLetter('z');
  static const EnglishLetter period = EnglishLetter('.');
  static const EnglishLetter empty = EnglishLetter('');

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

  bool isReflectionOf(EnglishLetter other) => reflection[this] == other;

  bool isRotationOf(EnglishLetter other) => rotation[this] == other;

  static Letter<English>? fromString(String string) {
    if (string.length != 1) {
      throw ArgumentError();
    }

    return stringMap[string];
  }
}
