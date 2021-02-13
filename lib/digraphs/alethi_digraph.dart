import 'package:womens_script_transliterator/letters/alethi_letter.dart';

import '../language.dart';
import 'digraph.dart';

class AlethiDigraph extends Digraph<Alethi> {
  const AlethiDigraph(AlethiLetter first, AlethiLetter second, String stringValue) : super(first, second, stringValue);

  static const List<AlethiDigraph> inputDigraphs = [ks, ku];
  static const List<AlethiDigraph> outputDigraphs = [kh, ki, ks, sh, si, sk, ss, th];

  static const kk = AlethiDigraph(AlethiLetter.k, AlethiLetter.k, 'kk');
  static const kh = AlethiDigraph(AlethiLetter.k, AlethiLetter.h, 'kh');
  static const ki = AlethiDigraph(AlethiLetter.k, AlethiLetter.i, 'ki');
  static const ks = AlethiDigraph(AlethiLetter.k, AlethiLetter.s, 'ks');
  static const ku = AlethiDigraph(AlethiLetter.k, AlethiLetter.u, 'ku');
  static const sh = AlethiDigraph(AlethiLetter.s, AlethiLetter.h, 'sh');
  static const si = AlethiDigraph(AlethiLetter.s, AlethiLetter.i, 'si');
  static const sk = AlethiDigraph(AlethiLetter.s, AlethiLetter.k, 'sk');
  static const ss = AlethiDigraph(AlethiLetter.s, AlethiLetter.s, 'ss');
  static const th = AlethiDigraph(AlethiLetter.t, AlethiLetter.h, 'th');

  static const Map<String, AlethiDigraph> stringMap = {
    'kk': kk,
    'kh': kh,
    'ki': ki,
    'ks': ks,
    'ku': ku,
    'sh': sh,
    'si': si,
    'sk': sk,
    'ss': ss,
    'th': th,
  };
}
