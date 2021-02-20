import 'digraphs/alethi_digraph.dart';
import 'digraphs/english_digraph.dart';
import 'language.dart';
import 'letters/alethi_letter.dart';
import 'letters/english_letter.dart';
import 'letters/letter.dart';

class Substitutions {
  static List<Letter<T>> getSubstitutions<S extends Language, T extends Language>(Letter<S> input) {
    switch (S) {
      case English:
        switch (T) {
          case Alethi:
            return (english2Alethi[input] ?? <Letter<T>>[]) as List<Letter<T>>;
          default:
            throw TypeError();
        }
      case Alethi:
        switch (T) {
          case English:
            return (alethi2English[input] ?? <Letter<T>>[]) as List<Letter<T>>;
          default:
            throw TypeError();
        }
      default:
        throw TypeError();
    }
  }

  static const Map<Letter<English>, List<Letter<Alethi>>> english2Alethi = <Letter<English>, List<Letter<Alethi>>>{
    EnglishLetter.a: <Letter<Alethi>>[AlethiLetter.a],
    EnglishLetter.b: <Letter<Alethi>>[AlethiLetter.b],
    EnglishLetter.c: <Letter<Alethi>>[AlethiLetter.k, AlethiLetter.s],
    EnglishDigraph.ce: <Letter<Alethi>>[AlethiDigraph.ke, AlethiDigraph.se, AlethiLetter.sh],
    EnglishDigraph.ch: <Letter<Alethi>>[AlethiDigraph.kh, AlethiDigraph.sh, AlethiLetter.ch],
    EnglishDigraph.ci: <Letter<Alethi>>[AlethiDigraph.si, AlethiDigraph.ki, AlethiLetter.sh],
    EnglishDigraph.ck: <Letter<Alethi>>[AlethiLetter.k, AlethiDigraph.kk, AlethiDigraph.sk],
    EnglishLetter.d: <Letter<Alethi>>[AlethiLetter.d],
    EnglishLetter.e: <Letter<Alethi>>[AlethiLetter.e],
    EnglishLetter.f: <Letter<Alethi>>[AlethiLetter.f],
    EnglishLetter.g: <Letter<Alethi>>[AlethiLetter.g],
    EnglishLetter.h: <Letter<Alethi>>[AlethiLetter.h],
    EnglishLetter.i: <Letter<Alethi>>[AlethiLetter.i],
    EnglishLetter.j: <Letter<Alethi>>[AlethiLetter.j],
    EnglishLetter.k: <Letter<Alethi>>[AlethiLetter.k],
    EnglishLetter.l: <Letter<Alethi>>[AlethiLetter.l],
    EnglishLetter.m: <Letter<Alethi>>[AlethiLetter.m],
    EnglishLetter.n: <Letter<Alethi>>[AlethiLetter.n],
    EnglishLetter.o: <Letter<Alethi>>[AlethiLetter.o],
    EnglishLetter.p: <Letter<Alethi>>[AlethiLetter.p],
    EnglishLetter.q: <Letter<Alethi>>[AlethiLetter.k],
    EnglishLetter.r: <Letter<Alethi>>[AlethiLetter.r],
    EnglishLetter.s: <Letter<Alethi>>[AlethiLetter.s],
    EnglishDigraph.sc: <Letter<Alethi>>[AlethiLetter.s, AlethiDigraph.sk, AlethiDigraph.ss],
    EnglishDigraph.sh: <Letter<Alethi>>[AlethiDigraph.sh, AlethiLetter.sh],
    EnglishLetter.t: <Letter<Alethi>>[AlethiLetter.t],
    EnglishDigraph.th: <Letter<Alethi>>[AlethiDigraph.th, AlethiLetter.th],
    EnglishLetter.u: <Letter<Alethi>>[AlethiLetter.u],
    EnglishLetter.v: <Letter<Alethi>>[AlethiLetter.v],
    EnglishLetter.w: <Letter<Alethi>>[AlethiLetter.u],
    EnglishDigraph.wr: <Letter<Alethi>>[AlethiLetter.r, AlethiDigraph.ur],
    EnglishLetter.x: <Letter<Alethi>>[AlethiLetter.x, AlethiLetter.z],
    EnglishLetter.y: <Letter<Alethi>>[AlethiLetter.y],
    EnglishLetter.z: <Letter<Alethi>>[AlethiLetter.z],
  };

  //TODO: This should probably mirror the English2Alethi map more closely, so that it gives all the possible inputs that the Alethi word could have been transliterated from. At current it just gives options for the most likely/required changes when the English to Alethi transliteration was made.
  static const Map<Letter<Alethi>, List<Letter<English>>> alethi2English = <Letter<Alethi>, List<Letter<English>>>{
    AlethiLetter.a: <Letter<English>>[EnglishLetter.a],
    AlethiLetter.b: <Letter<English>>[EnglishLetter.b],
    AlethiLetter.ch: <Letter<English>>[EnglishDigraph.ch],
    AlethiLetter.d: <Letter<English>>[EnglishLetter.d],
    AlethiLetter.e: <Letter<English>>[EnglishLetter.e],
    AlethiLetter.f: <Letter<English>>[EnglishLetter.f],
    AlethiLetter.g: <Letter<English>>[EnglishLetter.g],
    AlethiLetter.h: <Letter<English>>[EnglishLetter.h],
    AlethiLetter.i: <Letter<English>>[EnglishLetter.i],
    AlethiLetter.j: <Letter<English>>[EnglishLetter.j],
    AlethiLetter.k: <Letter<English>>[EnglishLetter.c, EnglishLetter.k, EnglishDigraph.ck],
    AlethiDigraph.ks: <Letter<English>>[EnglishDigraph.ks, EnglishLetter.x],
    AlethiDigraph.ku: <Letter<English>>[EnglishDigraph.qu, EnglishDigraph.kw, EnglishDigraph.ku],
    AlethiLetter.l: <Letter<English>>[EnglishLetter.l],
    AlethiLetter.m: <Letter<English>>[EnglishLetter.m],
    AlethiLetter.n: <Letter<English>>[EnglishLetter.n],
    AlethiLetter.o: <Letter<English>>[EnglishLetter.o],
    AlethiLetter.p: <Letter<English>>[EnglishLetter.p],
    AlethiLetter.r: <Letter<English>>[EnglishLetter.r],
    AlethiLetter.s: <Letter<English>>[EnglishLetter.s],
    AlethiLetter.sh: <Letter<English>>[EnglishDigraph.sh],
    AlethiLetter.t: <Letter<English>>[EnglishLetter.t],
    AlethiLetter.th: <Letter<English>>[EnglishDigraph.th],
    AlethiLetter.u: <Letter<English>>[EnglishLetter.u, EnglishLetter.w],
    AlethiLetter.x: <Letter<English>>[EnglishLetter.x],
    AlethiLetter.v: <Letter<English>>[EnglishLetter.v],
    AlethiLetter.y: <Letter<English>>[EnglishLetter.y],
    AlethiLetter.z: <Letter<English>>[EnglishLetter.z],
  };
}
