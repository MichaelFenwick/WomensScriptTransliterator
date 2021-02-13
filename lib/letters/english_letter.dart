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

  //</editor-fold>

  static const Map<String, EnglishLetter> stringMap = {
    'a': EnglishLetter.a,
    'b': EnglishLetter.b,
    'c': EnglishLetter.c,
    'd': EnglishLetter.d,
    'e': EnglishLetter.e,
    'f': EnglishLetter.f,
    'g': EnglishLetter.g,
    'h': EnglishLetter.h,
    'i': EnglishLetter.i,
    'j': EnglishLetter.j,
    'k': EnglishLetter.k,
    'l': EnglishLetter.l,
    'm': EnglishLetter.m,
    'n': EnglishLetter.n,
    'o': EnglishLetter.o,
    'p': EnglishLetter.p,
    'q': EnglishLetter.q,
    'r': EnglishLetter.r,
    's': EnglishLetter.s,
    't': EnglishLetter.t,
    'u': EnglishLetter.u,
    'v': EnglishLetter.v,
    'w': EnglishLetter.w,
    'x': EnglishLetter.x,
    'y': EnglishLetter.y,
    'z': EnglishLetter.z,
  };

  static const List<EnglishLetter> alphabet = [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z];

  //TODO: add reflection map and isReflection method

  static const Map<EnglishLetter, EnglishLetter> rotation = {
    EnglishLetter.b: EnglishLetter.q,
    EnglishLetter.d: EnglishLetter.p,
    EnglishLetter.l: EnglishLetter.l,
    EnglishLetter.o: EnglishLetter.o,
    EnglishLetter.p: EnglishLetter.d,
    EnglishLetter.q: EnglishLetter.b,
    EnglishLetter.s: EnglishLetter.s,
    EnglishLetter.x: EnglishLetter.x,
    EnglishLetter.z: EnglishLetter.z,
  };

  bool isRotationOf(EnglishLetter other) => rotation[this] == other;

  static EnglishLetter fromString(String string) {
    if (string.length != 1) {
      throw ArgumentError;
    }

    return stringMap[string];
  }
}
