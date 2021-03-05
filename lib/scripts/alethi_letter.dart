import 'language.dart';
import 'letter.dart';

enum AlethiLetterShape { line, leftTriangle, rightTriangle, diamond, leftDoubleTriangle, none }
enum AlethiLetterSize { three, two, one, oneTick, twoTicks, none }

class AlethiLetter extends Letter<Alethi> {
  final AlethiLetterShape shape;
  final AlethiLetterSize size;

  const AlethiLetter(String stringValue, {this.shape = AlethiLetterShape.none, this.size = AlethiLetterSize.none}) : super(stringValue);

  static Letter<Alethi> fromString(String string) => stringMap[string] ?? Letter<Alethi>(string);

  //<editor-fold desc="AlethiLetter const definitions" default-state="collapsed">
  static const Letter<Alethi> a = AlethiLetter('a', shape: AlethiLetterShape.line, size: AlethiLetterSize.two);
  static const Letter<Alethi> b = AlethiLetter('b', shape: AlethiLetterShape.diamond, size: AlethiLetterSize.two);
  static const Letter<Alethi> ch = AlethiLetter('C', shape: AlethiLetterShape.leftDoubleTriangle, size: AlethiLetterSize.oneTick);
  static const Letter<Alethi> d = AlethiLetter('d', shape: AlethiLetterShape.leftTriangle, size: AlethiLetterSize.two);
  static const Letter<Alethi> e = AlethiLetter('e', shape: AlethiLetterShape.line, size: AlethiLetterSize.three);
  static const Letter<Alethi> f = AlethiLetter('f', shape: AlethiLetterShape.diamond, size: AlethiLetterSize.oneTick);
  static const Letter<Alethi> g = AlethiLetter('g', shape: AlethiLetterShape.leftDoubleTriangle, size: AlethiLetterSize.two);
  static const Letter<Alethi> h = AlethiLetter('h', shape: AlethiLetterShape.rightTriangle, size: AlethiLetterSize.twoTicks);
  static const Letter<Alethi> i = AlethiLetter('i', shape: AlethiLetterShape.line, size: AlethiLetterSize.twoTicks);
  static const Letter<Alethi> j = AlethiLetter('j', shape: AlethiLetterShape.leftDoubleTriangle, size: AlethiLetterSize.twoTicks);
  static const Letter<Alethi> k = AlethiLetter('k', shape: AlethiLetterShape.leftDoubleTriangle, size: AlethiLetterSize.three);
  static const Letter<Alethi> l = AlethiLetter('l', shape: AlethiLetterShape.leftTriangle, size: AlethiLetterSize.twoTicks);
  static const Letter<Alethi> m = AlethiLetter('m', shape: AlethiLetterShape.diamond, size: AlethiLetterSize.one);
  static const Letter<Alethi> n = AlethiLetter('n', shape: AlethiLetterShape.rightTriangle, size: AlethiLetterSize.one);
  static const Letter<Alethi> o = AlethiLetter('o', shape: AlethiLetterShape.line, size: AlethiLetterSize.one);
  static const Letter<Alethi> p = AlethiLetter('p', shape: AlethiLetterShape.diamond, size: AlethiLetterSize.three);
  static const Letter<Alethi> r = AlethiLetter('r', shape: AlethiLetterShape.leftTriangle, size: AlethiLetterSize.one);
  static const Letter<Alethi> s = AlethiLetter('s', shape: AlethiLetterShape.rightTriangle, size: AlethiLetterSize.three);
  static const Letter<Alethi> sh = AlethiLetter('>', shape: AlethiLetterShape.rightTriangle, size: AlethiLetterSize.oneTick);
  static const Letter<Alethi> t = AlethiLetter('t', shape: AlethiLetterShape.leftTriangle, size: AlethiLetterSize.three);
  static const Letter<Alethi> th = AlethiLetter('<', shape: AlethiLetterShape.leftTriangle, size: AlethiLetterSize.oneTick);
  static const Letter<Alethi> u = AlethiLetter('u', shape: AlethiLetterShape.line, size: AlethiLetterSize.oneTick);
  static const Letter<Alethi> v = AlethiLetter('v', shape: AlethiLetterShape.diamond, size: AlethiLetterSize.twoTicks);
  static const Letter<Alethi> x = AlethiLetter('x', size: AlethiLetterSize.three);
  static const Letter<Alethi> y = AlethiLetter('y', shape: AlethiLetterShape.leftDoubleTriangle, size: AlethiLetterSize.one);
  static const Letter<Alethi> z = AlethiLetter('z', shape: AlethiLetterShape.rightTriangle, size: AlethiLetterSize.two);
  static const Letter<Alethi> period = AlethiLetter('.', shape: AlethiLetterShape.line, size: AlethiLetterSize.three);
  static const Letter<Alethi> empty = AlethiLetter('');
  //</editor-fold>

  static const Map<String, Letter<Alethi>> stringMap = <String, Letter<Alethi>>{
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

  static const List<Letter<Alethi>> alphabet = <Letter<Alethi>>[a, b, ch, d, e, f, g, h, i, j, k, l, m, n, o, p, r, s, sh, t, th, u, v, x, y, z, period];

  int getTickMarkCount() {
    switch (size) {
      case AlethiLetterSize.oneTick:
        return 2;
      case AlethiLetterSize.twoTicks:
        return 1;
      case AlethiLetterSize.three:
      case AlethiLetterSize.two:
      case AlethiLetterSize.one:
      case AlethiLetterSize.none:
        return 0;
    }
  }

  int getHeight() {
    switch (size) {
      case AlethiLetterSize.three:
        return 3;
      case AlethiLetterSize.two:
      case AlethiLetterSize.oneTick:
        return 2;
      case AlethiLetterSize.one:
      case AlethiLetterSize.twoTicks:
        return 1;
      case AlethiLetterSize.none:
        return 0;
    }
  }

  static const Map<Letter<Alethi>, Letter<Alethi>> reflection = <Letter<Alethi>, Letter<Alethi>>{
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

  //Because they are all horizontally symmetric, any letters with vertical symmetry are also rotational symmetric.
  static const Map<Letter<Alethi>, Letter<Alethi>> rotation = reflection;

  @override
  bool isReflectionOf(Letter<Alethi> other) => reflection[this] == other;

  @override
  bool isRotationOf(Letter<Alethi> other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
