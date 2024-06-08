import 'alethi_glyph.dart';
import 'glyph.dart';
import 'script.dart';

class AlethiGlyphGroup {
  final List<Glyph<Alethi>> glyphs;
  final String glyphsString;

  const AlethiGlyphGroup(this.glyphs, this.glyphsString);

  //Size Classes
  static const AlethiGlyphGroup oneUnit = AlethiGlyphGroup(<Glyph<Alethi>>[
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

  static const AlethiGlyphGroup twoUnit = AlethiGlyphGroup(<Glyph<Alethi>>[
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

  static const AlethiGlyphGroup threeUnit = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.e,
    AlethiGlyph.k,
    AlethiGlyph.p,
    AlethiGlyph.s,
    AlethiGlyph.t,
  ], 'ekpst');

  //Hash Classes
  static const AlethiGlyphGroup oneHash = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.h,
    AlethiGlyph.i,
    AlethiGlyph.j,
    AlethiGlyph.l,
    AlethiGlyph.v,
  ], 'hijlv');

  static const AlethiGlyphGroup twoHash = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.ch,
    AlethiGlyph.f,
    AlethiGlyph.sh,
    AlethiGlyph.th,
    AlethiGlyph.u,
  ], 'Cf><u');

  static const AlethiGlyphGroup noHash = AlethiGlyphGroup(<Glyph<Alethi>>[
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
  static const AlethiGlyphGroup eShape = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.a,
    AlethiGlyph.e,
    AlethiGlyph.i,
    AlethiGlyph.o,
    AlethiGlyph.u,
  ], 'aeiou');

  static const AlethiGlyphGroup kShape = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.ch,
    AlethiGlyph.g,
    AlethiGlyph.j,
    AlethiGlyph.k,
    AlethiGlyph.y,
  ], 'Cgjky');

  static const AlethiGlyphGroup pShape = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.b,
    AlethiGlyph.f,
    AlethiGlyph.m,
    AlethiGlyph.p,
    AlethiGlyph.v,
  ], 'bfmpv');

  static const AlethiGlyphGroup sShape = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.h,
    AlethiGlyph.n,
    AlethiGlyph.s,
    AlethiGlyph.sh,
    AlethiGlyph.z,
  ], 'hns>z');

  static const AlethiGlyphGroup tShape = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.d,
    AlethiGlyph.l,
    AlethiGlyph.r,
    AlethiGlyph.t,
    AlethiGlyph.th,
  ], 'dlrt<');

  //Kerning Classes
  static const AlethiGlyphGroup leftPoint = AlethiGlyphGroup(<Glyph<Alethi>>[
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

  static const AlethiGlyphGroup leftLine = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.h,
    AlethiGlyph.n,
    AlethiGlyph.s,
    AlethiGlyph.sh,
    AlethiGlyph.z,
  ], 'hns>z');

  static const AlethiGlyphGroup leftVowelLine = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.a,
    AlethiGlyph.e,
    AlethiGlyph.i,
    AlethiGlyph.o,
    AlethiGlyph.u,
  ], 'aeiou');

  static const AlethiGlyphGroup rightPoint = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.b,
    AlethiGlyph.m,
    AlethiGlyph.n,
    AlethiGlyph.p,
    AlethiGlyph.s,
    AlethiGlyph.z,
  ], 'bmnpsz');

  static const AlethiGlyphGroup rightLine = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.d,
    AlethiGlyph.g,
    AlethiGlyph.k,
    AlethiGlyph.r,
    AlethiGlyph.t,
    AlethiGlyph.y,
  ], 'dgkrty');

  static const AlethiGlyphGroup rightVowelLine = AlethiGlyphGroup(<Glyph<Alethi>>[
    AlethiGlyph.a,
    AlethiGlyph.e,
    AlethiGlyph.o,
  ], 'aeo');

  static const AlethiGlyphGroup rightHash = AlethiGlyphGroup(<Glyph<Alethi>>[
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
