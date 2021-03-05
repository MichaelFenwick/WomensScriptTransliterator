import 'alethi_letter.dart';
import 'language.dart';
import 'letter.dart';

class AlethiLetterGroup {
  final List<Letter<Alethi>> letters;
  final String lettersString;

  const AlethiLetterGroup(this.letters, this.lettersString);

  //Size Classes
  static const AlethiLetterGroup oneUnit = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.h,
    AlethiLetter.i,
    AlethiLetter.j,
    AlethiLetter.l,
    AlethiLetter.m,
    AlethiLetter.n,
    AlethiLetter.o,
    AlethiLetter.r,
    AlethiLetter.v,
    AlethiLetter.y,
  ], 'hijlmnorvy');

  static const AlethiLetterGroup twoUnit = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.a,
    AlethiLetter.b,
    AlethiLetter.ch,
    AlethiLetter.d,
    AlethiLetter.f,
    AlethiLetter.g,
    AlethiLetter.u,
    AlethiLetter.sh,
    AlethiLetter.th,
    AlethiLetter.z,
  ], 'abCdfgu><z');

  static const AlethiLetterGroup threeUnit = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.e,
    AlethiLetter.k,
    AlethiLetter.p,
    AlethiLetter.s,
    AlethiLetter.t,
  ], 'ekpst');

  //Hash Classes
  static const AlethiLetterGroup oneHash = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.h,
    AlethiLetter.i,
    AlethiLetter.j,
    AlethiLetter.l,
    AlethiLetter.v,
  ], 'hijlv');

  static const AlethiLetterGroup twoHash = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.ch,
    AlethiLetter.f,
    AlethiLetter.sh,
    AlethiLetter.th,
    AlethiLetter.u,
  ], 'Cf><u');

  static const AlethiLetterGroup noHash = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.a,
    AlethiLetter.b,
    AlethiLetter.d,
    AlethiLetter.e,
    AlethiLetter.g,
    AlethiLetter.k,
    AlethiLetter.m,
    AlethiLetter.n,
    AlethiLetter.o,
    AlethiLetter.p,
    AlethiLetter.r,
    AlethiLetter.s,
    AlethiLetter.t,
    AlethiLetter.y,
    AlethiLetter.z,
  ], 'abdegkmnoprstyz');

  //Shape Classes
  static const AlethiLetterGroup leftTriangle = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.d,
    AlethiLetter.l,
    AlethiLetter.r,
    AlethiLetter.t,
    AlethiLetter.th,
  ], 'dlrt<');

  static const AlethiLetterGroup rightTriangle = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.h,
    AlethiLetter.n,
    AlethiLetter.s,
    AlethiLetter.sh,
    AlethiLetter.z,
  ], 'hns>z');

  static const AlethiLetterGroup diamond = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.b,
    AlethiLetter.f,
    AlethiLetter.m,
    AlethiLetter.p,
    AlethiLetter.v,
  ], 'bfmpv');

  static const AlethiLetterGroup doubleTriangle = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.ch,
    AlethiLetter.g,
    AlethiLetter.j,
    AlethiLetter.k,
    AlethiLetter.y,
  ], 'Cgjky');

  static const AlethiLetterGroup line = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.a,
    AlethiLetter.e,
    AlethiLetter.i,
    AlethiLetter.o,
    AlethiLetter.u,
  ], 'aeiou');

  //Kerning Classes
  static const AlethiLetterGroup leftPoint = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.b,
    AlethiLetter.ch,
    AlethiLetter.d,
    AlethiLetter.f,
    AlethiLetter.g,
    AlethiLetter.j,
    AlethiLetter.k,
    AlethiLetter.l,
    AlethiLetter.m,
    AlethiLetter.p,
    AlethiLetter.r,
    AlethiLetter.t,
    AlethiLetter.th,
    AlethiLetter.v,
    AlethiLetter.y,
  ], 'bCdfgjklmprt<vy');

  static const AlethiLetterGroup leftLine = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.h,
    AlethiLetter.n,
    AlethiLetter.s,
    AlethiLetter.sh,
    AlethiLetter.z,
  ], 'hns>z');

  static const AlethiLetterGroup leftVowelLine = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.a,
    AlethiLetter.e,
    AlethiLetter.i,
    AlethiLetter.o,
    AlethiLetter.u,
  ], 'aeiou');

  static const AlethiLetterGroup rightPoint = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.b,
    AlethiLetter.m,
    AlethiLetter.n,
    AlethiLetter.p,
    AlethiLetter.s,
    AlethiLetter.z,
  ], 'bmnpsz');

  static const AlethiLetterGroup rightLine = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.d,
    AlethiLetter.g,
    AlethiLetter.k,
    AlethiLetter.r,
    AlethiLetter.t,
    AlethiLetter.y,
  ], 'dgkrty');

  static const AlethiLetterGroup rightVowelLine = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.a,
    AlethiLetter.e,
    AlethiLetter.o,
  ], 'aeo');

  static const AlethiLetterGroup rightHash = AlethiLetterGroup(<Letter<Alethi>>[
    AlethiLetter.ch,
    AlethiLetter.f,
    AlethiLetter.h,
    AlethiLetter.i,
    AlethiLetter.j,
    AlethiLetter.l,
    AlethiLetter.sh,
    AlethiLetter.th,
    AlethiLetter.u,
    AlethiLetter.v,
  ], 'Cfhijl><uv');
}
