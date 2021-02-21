import '../language.dart';
import '../letters/alethi_letter.dart';
import 'digraph.dart';

class AlethiDigraph extends Digraph<Alethi> {
  const AlethiDigraph(AlethiLetter first, AlethiLetter second, String stringValue) : super(first, second, stringValue);

  static const List<Digraph<Alethi>> inputDigraphs = <Digraph<Alethi>>[ks, ku];
  static const List<Digraph<Alethi>> outputDigraphs = <Digraph<Alethi>>[ke, kh, ki, ks, se, sh, si, sk, ss, th, ur];

  static const AlethiDigraph ke = AlethiDigraph(AlethiLetter.k, AlethiLetter.e, 'ke');
  static const AlethiDigraph kk = AlethiDigraph(AlethiLetter.k, AlethiLetter.k, 'kk');
  static const AlethiDigraph kh = AlethiDigraph(AlethiLetter.k, AlethiLetter.h, 'kh');
  static const AlethiDigraph ki = AlethiDigraph(AlethiLetter.k, AlethiLetter.i, 'ki');
  static const AlethiDigraph ks = AlethiDigraph(AlethiLetter.k, AlethiLetter.s, 'ks');
  static const AlethiDigraph ku = AlethiDigraph(AlethiLetter.k, AlethiLetter.u, 'ku');
  static const AlethiDigraph se = AlethiDigraph(AlethiLetter.s, AlethiLetter.e, 'se');
  static const AlethiDigraph sh = AlethiDigraph(AlethiLetter.s, AlethiLetter.h, 'sh');
  static const AlethiDigraph si = AlethiDigraph(AlethiLetter.s, AlethiLetter.i, 'si');
  static const AlethiDigraph sk = AlethiDigraph(AlethiLetter.s, AlethiLetter.k, 'sk');
  static const AlethiDigraph ss = AlethiDigraph(AlethiLetter.s, AlethiLetter.s, 'ss');
  static const AlethiDigraph th = AlethiDigraph(AlethiLetter.t, AlethiLetter.h, 'th');
  static const AlethiDigraph ur = AlethiDigraph(AlethiLetter.u, AlethiLetter.r, 'ur');
  static const AlethiDigraph empty = AlethiDigraph(AlethiLetter.empty, AlethiLetter.empty, '');

  static const Map<String, Digraph<Alethi>> stringMap = <String, Digraph<Alethi>>{
    'ke': ke,
    'kk': kk,
    'kh': kh,
    'ki': ki,
    'ks': ks,
    'ku': ku,
    'se': se,
    'sh': sh,
    'si': si,
    'sk': sk,
    'ss': ss,
    'th': th,
    'ur': ur,
  };
}
