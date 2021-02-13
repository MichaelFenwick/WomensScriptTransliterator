import 'alethi_letter.dart';

class AlethiLetterGroup {
  final List<AlethiLetter> letters;
  final String lettersString;

  const AlethiLetterGroup(this.letters, this.lettersString);

  //Size Classes
  static const AlethiLetterGroup oneUnit = AlethiLetterGroup([
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
  ], r'hijlmnorvy');

  static const AlethiLetterGroup twoUnit = AlethiLetterGroup([
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
  ], r'abCdfgu><z');

  static const AlethiLetterGroup threeUnit = AlethiLetterGroup([
    AlethiLetter.e,
    AlethiLetter.k,
    AlethiLetter.p,
    AlethiLetter.s,
    AlethiLetter.t,
  ], r'ekpst');

  //Hash Classes
  static const AlethiLetterGroup oneHash = AlethiLetterGroup([
    AlethiLetter.h,
    AlethiLetter.i,
    AlethiLetter.j,
    AlethiLetter.l,
    AlethiLetter.v,
  ], r'hijlv');

  static const AlethiLetterGroup twoHash = AlethiLetterGroup([
    AlethiLetter.ch,
    AlethiLetter.f,
    AlethiLetter.sh,
    AlethiLetter.th,
    AlethiLetter.u,
  ], r'Cf><u');

  static const AlethiLetterGroup noHash = AlethiLetterGroup([
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
  ], r'abdegkmnoprstyz');

  //Shape Classes
  static const AlethiLetterGroup leftTriangle = AlethiLetterGroup([
    AlethiLetter.d,
    AlethiLetter.l,
    AlethiLetter.r,
    AlethiLetter.t,
    AlethiLetter.th,
  ], r'dlrt<');

  static const AlethiLetterGroup rightTriangle = AlethiLetterGroup([
    AlethiLetter.h,
    AlethiLetter.n,
    AlethiLetter.s,
    AlethiLetter.sh,
    AlethiLetter.z,
  ], r'hns>z');

  static const AlethiLetterGroup diamond = AlethiLetterGroup([
    AlethiLetter.b,
    AlethiLetter.f,
    AlethiLetter.m,
    AlethiLetter.p,
    AlethiLetter.v,
  ], r'bfmpv');

  static const AlethiLetterGroup doubleTriangle = AlethiLetterGroup([
    AlethiLetter.ch,
    AlethiLetter.g,
    AlethiLetter.j,
    AlethiLetter.k,
    AlethiLetter.y,
  ], r'Cgjky');

  static const AlethiLetterGroup line = AlethiLetterGroup([
    AlethiLetter.a,
    AlethiLetter.e,
    AlethiLetter.i,
    AlethiLetter.o,
    AlethiLetter.u,
  ], r'aeiou');

  //Kerning Classes
  static const AlethiLetterGroup leftPoint = AlethiLetterGroup([
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
  ], r'bCdfgjklmprt<vy');

  static const AlethiLetterGroup leftLine = AlethiLetterGroup([
    AlethiLetter.h,
    AlethiLetter.n,
    AlethiLetter.s,
    AlethiLetter.sh,
    AlethiLetter.z,
  ], r'hns>z');

  static const AlethiLetterGroup leftVowelLine = AlethiLetterGroup([
    AlethiLetter.a,
    AlethiLetter.e,
    AlethiLetter.i,
    AlethiLetter.o,
    AlethiLetter.u,
  ], r'aeiou');

  static const AlethiLetterGroup rightPoint = AlethiLetterGroup([
    AlethiLetter.b,
    AlethiLetter.m,
    AlethiLetter.n,
    AlethiLetter.p,
    AlethiLetter.s,
    AlethiLetter.z,
  ], r'bmnpsz');

  static const AlethiLetterGroup rightLine = AlethiLetterGroup([
    AlethiLetter.d,
    AlethiLetter.g,
    AlethiLetter.k,
    AlethiLetter.r,
    AlethiLetter.t,
    AlethiLetter.y,
  ], r'dgkrty');

  static const AlethiLetterGroup rightVowelLine = AlethiLetterGroup([
    AlethiLetter.a,
    AlethiLetter.e,
    AlethiLetter.o,
  ], r'aeo');

  static const AlethiLetterGroup rightHash = AlethiLetterGroup([
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
  ], r'Cfhijl><uv');
}
