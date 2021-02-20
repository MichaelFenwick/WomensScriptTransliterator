import '../language.dart';
import '../letters/english_letter.dart';
import '../letters/letter.dart';
import 'digraph.dart';

class EnglishDigraph extends Digraph<English> {
  const EnglishDigraph(Letter<English> first, Letter<English> second, String stringValue) : super(first, second, stringValue);

  static const List<Digraph<English>> inputDigraphs = <Digraph<English>>[ce, ch, ci, ck, sc, sh, th, wr];
  static const List<Digraph<English>> outputDigraphs = <Digraph<English>>[ch, ci, ck, ks, ku, kw, qu, sc, sh, th];

  static const EnglishDigraph ce = EnglishDigraph(EnglishLetter.c, EnglishLetter.h, 'ce');
  static const EnglishDigraph ch = EnglishDigraph(EnglishLetter.c, EnglishLetter.h, 'ch');
  static const EnglishDigraph ci = EnglishDigraph(EnglishLetter.c, EnglishLetter.i, 'ci');
  static const EnglishDigraph ck = EnglishDigraph(EnglishLetter.c, EnglishLetter.k, 'ck');
  static const EnglishDigraph ks = EnglishDigraph(EnglishLetter.k, EnglishLetter.s, 'ks');
  static const EnglishDigraph ku = EnglishDigraph(EnglishLetter.k, EnglishLetter.u, 'ku');
  static const EnglishDigraph kw = EnglishDigraph(EnglishLetter.k, EnglishLetter.w, 'kw');
  static const EnglishDigraph qu = EnglishDigraph(EnglishLetter.q, EnglishLetter.u, 'qu');
  static const EnglishDigraph th = EnglishDigraph(EnglishLetter.t, EnglishLetter.h, 'th');
  static const EnglishDigraph sc = EnglishDigraph(EnglishLetter.s, EnglishLetter.c, 'sc');
  static const EnglishDigraph sh = EnglishDigraph(EnglishLetter.s, EnglishLetter.h, 'sh');
  static const EnglishDigraph wr = EnglishDigraph(EnglishLetter.w, EnglishLetter.r, 'wr');

  static const Map<String, Digraph<English>> stringMap = <String, Digraph<English>>{
    'ce': ce,
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
    'wr': wr,
  };
}
