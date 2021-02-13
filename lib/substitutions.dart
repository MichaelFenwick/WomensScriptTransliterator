import 'digraphs/alethi_digraph.dart';
import 'digraphs/english_digraph.dart';
import 'language.dart';
import 'letters/alethi_letter.dart';
import 'letters/english_letter.dart';
import 'letters/letter.dart';

class Substitutions {
  static List<Letter> getSubstitutions<S extends Language, T extends Language>(Letter input) {
    if (input.language != S) {
      return [input];
    }
    switch (S) {
      case English:
        switch (T) {
          case Alethi:
            return english2Alethi[input] ?? [];
          default:
            return [input];
        }
        break;
      case Alethi:
        switch (T) {
          case English:
            return alethi2English[input] ?? [];
          default:
            return [input];
        }
        break;
      default:
        return [input];
    }
  }

  static const Map<Letter<English>, List<Letter<Alethi>>> english2Alethi = {
    EnglishLetter.a: [AlethiLetter.a],
    EnglishLetter.b: [AlethiLetter.b],
    EnglishLetter.c: [AlethiLetter.k, AlethiLetter.s],
    EnglishDigraph.ch: [AlethiDigraph.kh, AlethiDigraph.sh, AlethiLetter.ch],
    EnglishDigraph.ci: [AlethiDigraph.si, AlethiDigraph.ki, AlethiLetter.sh],
    EnglishDigraph.ck: [AlethiLetter.k, AlethiDigraph.kk, AlethiDigraph.sk],
    EnglishLetter.d: [AlethiLetter.d],
    EnglishLetter.e: [AlethiLetter.e],
    EnglishLetter.f: [AlethiLetter.f],
    EnglishLetter.g: [AlethiLetter.g],
    EnglishLetter.h: [AlethiLetter.h],
    EnglishLetter.i: [AlethiLetter.i],
    EnglishLetter.j: [AlethiLetter.j],
    EnglishLetter.k: [AlethiLetter.k],
    EnglishLetter.l: [AlethiLetter.l],
    EnglishLetter.m: [AlethiLetter.m],
    EnglishLetter.n: [AlethiLetter.n],
    EnglishLetter.o: [AlethiLetter.o],
    EnglishLetter.p: [AlethiLetter.p],
    EnglishLetter.q: [AlethiLetter.k],
    EnglishLetter.r: [AlethiLetter.r],
    EnglishLetter.s: [AlethiLetter.s],
    EnglishDigraph.sc: [AlethiLetter.s, AlethiDigraph.sk, AlethiDigraph.ss],
    EnglishDigraph.sh: [AlethiDigraph.sh, AlethiLetter.sh],
    EnglishLetter.t: [AlethiLetter.t],
    EnglishDigraph.th: [AlethiDigraph.th, AlethiLetter.th],
    EnglishLetter.u: [AlethiLetter.u],
    EnglishLetter.v: [AlethiLetter.v],
    EnglishLetter.w: [AlethiLetter.u],
    EnglishLetter.x: [AlethiDigraph.ks, AlethiLetter.z],
    EnglishLetter.y: [AlethiLetter.y],
    EnglishLetter.z: [AlethiLetter.z],
  };

  //TODO: This should probably mirror the English2Alethi map more closely, so that it gives all the possible inputs that the Alethi word could have been transliterated from. At current it just gives options for the most likely/required changes when the English to Alethi transliteration was made.
  static const Map<Letter<Alethi>, List<Letter<English>>> alethi2English = {
    AlethiLetter.a: [EnglishLetter.a],
    AlethiLetter.b: [EnglishLetter.b],
    AlethiLetter.ch: [EnglishDigraph.ch],
    AlethiLetter.d: [EnglishLetter.d],
    AlethiLetter.e: [EnglishLetter.e],
    AlethiLetter.f: [EnglishLetter.f],
    AlethiLetter.g: [EnglishLetter.g],
    AlethiLetter.h: [EnglishLetter.h],
    AlethiLetter.i: [EnglishLetter.i],
    AlethiLetter.j: [EnglishLetter.j],
    AlethiLetter.k: [EnglishLetter.c, EnglishLetter.k, EnglishDigraph.ck],
    AlethiDigraph.ks: [EnglishDigraph.ks, EnglishLetter.x],
    AlethiDigraph.ku: [EnglishDigraph.qu, EnglishDigraph.kw, EnglishDigraph.ku],
    AlethiLetter.l: [EnglishLetter.l],
    AlethiLetter.m: [EnglishLetter.m],
    AlethiLetter.n: [EnglishLetter.n],
    AlethiLetter.o: [EnglishLetter.o],
    AlethiLetter.p: [EnglishLetter.p],
    AlethiLetter.r: [EnglishLetter.r],
    AlethiLetter.s: [EnglishLetter.s],
    AlethiLetter.sh: [EnglishDigraph.sh],
    AlethiLetter.t: [EnglishLetter.t],
    AlethiLetter.th: [EnglishDigraph.th],
    AlethiLetter.u: [EnglishLetter.u, EnglishLetter.w],
    AlethiLetter.v: [EnglishLetter.v],
    AlethiLetter.y: [EnglishLetter.y],
    AlethiLetter.z: [EnglishLetter.z],
  };
}
