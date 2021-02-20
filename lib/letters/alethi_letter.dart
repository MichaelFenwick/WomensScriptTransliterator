import '../language.dart';
import 'letter.dart';

enum AlethiLetterType { line, leftTriangle, rightTriangle, diamond, leftDoubleTriangle, none }
enum AlethiLetterSize { three, two, one, oneTick, twoTicks, none }

class AlethiLetter extends Letter<Alethi> {
  final AlethiLetterType letterType;
  final AlethiLetterSize letterSize;

  const AlethiLetter(this.letterType, this.letterSize, String stringValue) : super(stringValue);

  //<editor-fold desc="AlethiLetter const definitions" default-state="collapsed">
  static const AlethiLetter a = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.two, 'a');
  static const AlethiLetter b = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.two, 'b');
  static const AlethiLetter ch = AlethiLetter(AlethiLetterType.leftDoubleTriangle, AlethiLetterSize.oneTick, 'C');
  static const AlethiLetter d = AlethiLetter(AlethiLetterType.leftTriangle, AlethiLetterSize.two, 'd');
  static const AlethiLetter e = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.three, 'e');
  static const AlethiLetter f = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.oneTick, 'f');
  static const AlethiLetter g = AlethiLetter(AlethiLetterType.leftDoubleTriangle, AlethiLetterSize.two, 'g');
  static const AlethiLetter h = AlethiLetter(AlethiLetterType.rightTriangle, AlethiLetterSize.twoTicks, 'h');
  static const AlethiLetter i = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.twoTicks, 'i');
  static const AlethiLetter j = AlethiLetter(AlethiLetterType.leftDoubleTriangle, AlethiLetterSize.twoTicks, 'j');
  static const AlethiLetter k = AlethiLetter(AlethiLetterType.leftDoubleTriangle, AlethiLetterSize.three, 'k');
  static const AlethiLetter l = AlethiLetter(AlethiLetterType.leftTriangle, AlethiLetterSize.twoTicks, 'l');
  static const AlethiLetter m = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.one, 'm');
  static const AlethiLetter n = AlethiLetter(AlethiLetterType.rightTriangle, AlethiLetterSize.one, 'n');
  static const AlethiLetter o = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.one, 'o');
  static const AlethiLetter p = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.three, 'p');
  static const AlethiLetter r = AlethiLetter(AlethiLetterType.leftTriangle, AlethiLetterSize.one, 'r');
  static const AlethiLetter s = AlethiLetter(AlethiLetterType.rightTriangle, AlethiLetterSize.three, 's');
  static const AlethiLetter sh = AlethiLetter(AlethiLetterType.rightTriangle, AlethiLetterSize.oneTick, '>');
  static const AlethiLetter t = AlethiLetter(AlethiLetterType.leftTriangle, AlethiLetterSize.three, 't');
  static const AlethiLetter th = AlethiLetter(AlethiLetterType.leftTriangle, AlethiLetterSize.oneTick, '<');
  static const AlethiLetter u = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.oneTick, 'u');
  static const AlethiLetter v = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.twoTicks, 'v');
  static const AlethiLetter x = AlethiLetter(AlethiLetterType.none, AlethiLetterSize.three, 'x');
  static const AlethiLetter y = AlethiLetter(AlethiLetterType.leftDoubleTriangle, AlethiLetterSize.one, 'y');
  static const AlethiLetter z = AlethiLetter(AlethiLetterType.rightTriangle, AlethiLetterSize.two, 'z');
  static const AlethiLetter period = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.three, ',');
  static const AlethiLetter empty = AlethiLetter(AlethiLetterType.none, AlethiLetterSize.none, ',');
  //</editor-fold>

  static const Map<String, Letter<Alethi>> stringMap = <String, Letter<Alethi>>{
    'a': a,
    'b': b,
    'd': d,
    'e': e,
    'f': f,
    'g': g,
    'h': h,
    'i': i,
    'j': j,
    'k': k,
    'C': ch,
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
    switch (letterSize) {
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
    switch (letterSize) {
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

  static const Map<Letter<Alethi>, Letter<Alethi>> rotation =
      reflection; //Because they are all horizontally symmetric, any letters with vertical symmetry are also rotational symmetric.

  bool isReflectionOf(AlethiLetter other) => reflection[this] == other;

  bool isRotationOf(AlethiLetter other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
