import 'alethi_glyph.dart';

class AlethiGlyphGroup {
  final List<AlethiGlyph> glyphs;
  final String glyphsString;

  const AlethiGlyphGroup(this.glyphs, this.glyphsString);

  //Size Classes
  static const AlethiGlyphGroup oneUnit = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.h,
    AlethiGlyph.i,
    AlethiGlyph.j,
    AlethiGlyph.l,
    AlethiGlyph.m,
    AlethiGlyph.n,
    AlethiGlyph.o,
    AlethiGlyph.r,
    AlethiGlyph.v,
    AlethiGlyph.y,
  ], 'hijlmnorvy');

  static const AlethiGlyphGroup twoUnit = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.a,
    AlethiGlyph.b,
    AlethiGlyph.ch,
    AlethiGlyph.d,
    AlethiGlyph.f,
    AlethiGlyph.g,
    AlethiGlyph.u,
    AlethiGlyph.sh,
    AlethiGlyph.th,
    AlethiGlyph.z,
  ], 'abCdfgu><z');

  static const AlethiGlyphGroup threeUnit = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.e,
    AlethiGlyph.k,
    AlethiGlyph.p,
    AlethiGlyph.s,
    AlethiGlyph.t,
  ], 'ekpst');

  //Hash Classes
  static const AlethiGlyphGroup oneHash = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.h,
    AlethiGlyph.i,
    AlethiGlyph.j,
    AlethiGlyph.l,
    AlethiGlyph.v,
  ], 'hijlv');

  static const AlethiGlyphGroup twoHash = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.ch,
    AlethiGlyph.f,
    AlethiGlyph.sh,
    AlethiGlyph.th,
    AlethiGlyph.u,
  ], 'Cf><u');

  static const AlethiGlyphGroup noHash = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.a,
    AlethiGlyph.b,
    AlethiGlyph.d,
    AlethiGlyph.e,
    AlethiGlyph.g,
    AlethiGlyph.k,
    AlethiGlyph.m,
    AlethiGlyph.n,
    AlethiGlyph.o,
    AlethiGlyph.p,
    AlethiGlyph.r,
    AlethiGlyph.s,
    AlethiGlyph.t,
    AlethiGlyph.y,
    AlethiGlyph.z,
  ], 'abdegkmnoprstyz');

  //Shape Classes
  static const AlethiGlyphGroup eShape = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.a,
    AlethiGlyph.e,
    AlethiGlyph.i,
    AlethiGlyph.o,
    AlethiGlyph.u,
  ], 'aeiou');

  static const AlethiGlyphGroup kShape = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.ch,
    AlethiGlyph.g,
    AlethiGlyph.j,
    AlethiGlyph.k,
    AlethiGlyph.y,
  ], 'Cgjky');

  static const AlethiGlyphGroup pShape = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.b,
    AlethiGlyph.f,
    AlethiGlyph.m,
    AlethiGlyph.p,
    AlethiGlyph.v,
  ], 'bfmpv');

  static const AlethiGlyphGroup sShape = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.h,
    AlethiGlyph.n,
    AlethiGlyph.s,
    AlethiGlyph.sh,
    AlethiGlyph.z,
  ], 'hns>z');

  static const AlethiGlyphGroup tShape = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.d,
    AlethiGlyph.l,
    AlethiGlyph.r,
    AlethiGlyph.t,
    AlethiGlyph.th,
  ], 'dlrt<');

  //Kerning Classes
  static const AlethiGlyphGroup leftPoint = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.b,
    AlethiGlyph.ch,
    AlethiGlyph.d,
    AlethiGlyph.f,
    AlethiGlyph.g,
    AlethiGlyph.j,
    AlethiGlyph.k,
    AlethiGlyph.l,
    AlethiGlyph.m,
    AlethiGlyph.p,
    AlethiGlyph.r,
    AlethiGlyph.t,
    AlethiGlyph.th,
    AlethiGlyph.v,
    AlethiGlyph.y,
  ], 'bCdfgjklmprt<vy');

  static const AlethiGlyphGroup leftLine = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.h,
    AlethiGlyph.n,
    AlethiGlyph.s,
    AlethiGlyph.sh,
    AlethiGlyph.z,
  ], 'hns>z');

  static const AlethiGlyphGroup leftVowelLine = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.a,
    AlethiGlyph.e,
    AlethiGlyph.i,
    AlethiGlyph.o,
    AlethiGlyph.u,
  ], 'aeiou');

  static const AlethiGlyphGroup rightPoint = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.b,
    AlethiGlyph.m,
    AlethiGlyph.n,
    AlethiGlyph.p,
    AlethiGlyph.s,
    AlethiGlyph.z,
  ], 'bmnpsz');

  static const AlethiGlyphGroup rightLine = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.d,
    AlethiGlyph.g,
    AlethiGlyph.k,
    AlethiGlyph.r,
    AlethiGlyph.t,
    AlethiGlyph.y,
  ], 'dgkrty');

  static const AlethiGlyphGroup rightVowelLine = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.a,
    AlethiGlyph.e,
    AlethiGlyph.o,
  ], 'aeo');

  static const AlethiGlyphGroup rightHash = AlethiGlyphGroup(<AlethiGlyph>[
    AlethiGlyph.ch,
    AlethiGlyph.f,
    AlethiGlyph.h,
    AlethiGlyph.i,
    AlethiGlyph.j,
    AlethiGlyph.l,
    AlethiGlyph.sh,
    AlethiGlyph.th,
    AlethiGlyph.u,
    AlethiGlyph.v,
  ], 'Cfhijl><uv');
}
