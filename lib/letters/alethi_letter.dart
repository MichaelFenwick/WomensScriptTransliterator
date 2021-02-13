import '../language.dart';
import 'letter.dart';

enum AlethiLetterType { line, left_triangle, right_triangle, diamond, double_left_triangle }
enum AlethiLetterSize { three, two, one, two_tick, one_tick }

class AlethiLetter extends Letter<Alethi> {
  final AlethiLetterType letterType;
  final AlethiLetterSize letterSize;

  const AlethiLetter(this.letterType, this.letterSize, String stringValue) : super(stringValue);

  //<editor-fold desc="AlethiLetter const definitions" default-state="collapsed">
  static const AlethiLetter a = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.two, 'a');
  static const AlethiLetter b = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.two, 'b');
  static const AlethiLetter ch = AlethiLetter(AlethiLetterType.double_left_triangle, AlethiLetterSize.two_tick, 'C');
  static const AlethiLetter d = AlethiLetter(AlethiLetterType.left_triangle, AlethiLetterSize.two, 'd');
  static const AlethiLetter e = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.three, 'e');
  static const AlethiLetter f = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.two_tick, 'f');
  static const AlethiLetter g = AlethiLetter(AlethiLetterType.double_left_triangle, AlethiLetterSize.two, 'g');
  static const AlethiLetter h = AlethiLetter(AlethiLetterType.right_triangle, AlethiLetterSize.one_tick, 'h');
  static const AlethiLetter i = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.one_tick, 'i');
  static const AlethiLetter j = AlethiLetter(AlethiLetterType.double_left_triangle, AlethiLetterSize.one_tick, 'j');
  static const AlethiLetter k = AlethiLetter(AlethiLetterType.double_left_triangle, AlethiLetterSize.three, 'k');
  static const AlethiLetter l = AlethiLetter(AlethiLetterType.left_triangle, AlethiLetterSize.one_tick, 'l');
  static const AlethiLetter m = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.one, 'm');
  static const AlethiLetter n = AlethiLetter(AlethiLetterType.right_triangle, AlethiLetterSize.one, 'n');
  static const AlethiLetter o = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.one, 'o');
  static const AlethiLetter p = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.three, 'p');
  static const AlethiLetter r = AlethiLetter(AlethiLetterType.left_triangle, AlethiLetterSize.one, 'r');
  static const AlethiLetter s = AlethiLetter(AlethiLetterType.right_triangle, AlethiLetterSize.three, 's');
  static const AlethiLetter sh = AlethiLetter(AlethiLetterType.right_triangle, AlethiLetterSize.two_tick, '>');
  static const AlethiLetter t = AlethiLetter(AlethiLetterType.left_triangle, AlethiLetterSize.three, 't');
  static const AlethiLetter th = AlethiLetter(AlethiLetterType.left_triangle, AlethiLetterSize.two_tick, '<');
  static const AlethiLetter u = AlethiLetter(AlethiLetterType.line, AlethiLetterSize.two_tick, 'u');
  static const AlethiLetter v = AlethiLetter(AlethiLetterType.diamond, AlethiLetterSize.one_tick, 'v');
  static const AlethiLetter y = AlethiLetter(AlethiLetterType.double_left_triangle, AlethiLetterSize.one, 'y');
  static const AlethiLetter z = AlethiLetter(AlethiLetterType.right_triangle, AlethiLetterSize.two, 'z');
  //</editor-fold>

  static const stringMap = {
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
    'y': y,
    'z': z,
  };

  static const List<AlethiLetter> alphabet = [a, b, ch, d, e, f, g, h, i, j, k, l, m, n, o, p, r, s, sh, t, th, u, v, y, z];

  int getTickMarkCount() {
    switch (letterSize) {
      case AlethiLetterSize.three:
      case AlethiLetterSize.two:
      case AlethiLetterSize.one:
        return 0;
      case AlethiLetterSize.two_tick:
        return 2;
      case AlethiLetterSize.one_tick:
        return 1;
      default:
        return null;
    }
  }

  int getHeight() {
    switch (letterSize) {
      case AlethiLetterSize.three:
        return 3;
      case AlethiLetterSize.two:
      case AlethiLetterSize.two_tick:
        return 2;
      case AlethiLetterSize.one:
      case AlethiLetterSize.one_tick:
        return 1;
      default:
        return null;
    }
  }

  //TODO: add reflection map and isReflection method

  static const Map<AlethiLetter, AlethiLetter> rotation = {
    AlethiLetter.a: AlethiLetter.a,
    AlethiLetter.d: AlethiLetter.z,
    AlethiLetter.e: AlethiLetter.e,
    AlethiLetter.o: AlethiLetter.o,
    AlethiLetter.n: AlethiLetter.r,
    AlethiLetter.r: AlethiLetter.n,
    AlethiLetter.s: AlethiLetter.t,
    AlethiLetter.t: AlethiLetter.s,
    AlethiLetter.z: AlethiLetter.d
  };

  bool isRotationOf(AlethiLetter other) => rotation[this] == other;

  @override
  String toString() => stringValue;
}
