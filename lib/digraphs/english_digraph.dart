import 'package:womens_script_transliterator/letters/english_letter.dart';
import 'package:womens_script_transliterator/letters/letter.dart';

import '../language.dart';
import 'digraph.dart';

class EnglishDigraph extends Digraph<English> {
  const EnglishDigraph(Letter<English> first, Letter<English> second, String stringValue) : super(first, second, stringValue);

  static const List<Digraph<English>> inputDigraphs = [ch, ci, ck, sc, sh, th];
  static const List<Digraph<English>> outputDigraphs = [ch, ci, ck, ks, ku, kw, qu, sc, sh, th];

  static const ch = EnglishDigraph(EnglishLetter.c, EnglishLetter.h, 'ch');
  static const ci = EnglishDigraph(EnglishLetter.c, EnglishLetter.i, 'ci');
  static const ck = EnglishDigraph(EnglishLetter.c, EnglishLetter.k, 'ck');
  static const ks = EnglishDigraph(EnglishLetter.k, EnglishLetter.s, 'ks');
  static const ku = EnglishDigraph(EnglishLetter.k, EnglishLetter.u, 'ku');
  static const kw = EnglishDigraph(EnglishLetter.k, EnglishLetter.w, 'kw');
  static const qu = EnglishDigraph(EnglishLetter.q, EnglishLetter.u, 'qu');
  static const th = EnglishDigraph(EnglishLetter.t, EnglishLetter.h, 'th');
  static const sc = EnglishDigraph(EnglishLetter.s, EnglishLetter.c, 'sc');
  static const sh = EnglishDigraph(EnglishLetter.s, EnglishLetter.h, 'sh');

  static const Map<String, Digraph<English>> stringMap = {
    'ch': ch,
    'ci': ci,
    'ck': ck,
    'ks': ks,
    'ku': ku,
    'kw': kw,
    'qu': qu,
    'th': th,
    'sc': sc,
    'sh': sh,
  };
}
