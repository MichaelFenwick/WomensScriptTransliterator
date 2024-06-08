/// A [Script] represents the set of glyphs which might be transliterated to or from. While multiple languages might share a script in the strictest sense, the way in which they use that script changes dramatically, such that it is easier to consider the combination of a script (in the sense of a collection of glyphs) and a language as a singular [Script] object.
///
/// All languages which can be used as a transliteration context will have their native script specified by that language's name (this avoids the redundancy of names like "English Latin," "German Latin," "Russian Cyrillic," "Alethi Women's Script," etc.). In the event that a script exists which no language (which can be used as a transliteration context) can claim as its native script, the name for that script will be used directly as the name for the [Script] object.
///
/// A note about the distinction and relationship between a script and a language:
///
/// The line between a script and a language can be fuzzy. In particular, while two languages may use visually identical glyphs to represent their words, the interpretation of those glyphs will depend on the context of the language in which they are used. In the context of transliteration, it doesn't make sense to think of a script as strictly a set of glyphs, but rather as this union between the glyphs and their contextual meaning within a language, a state which blends ideas of "language" into that of "script," leading to potentially ambiguous nomenclature. What follows is a justification for the naming of [Script]s within this code, so as to provide a reference in case future confusion arises.
///
/// Transliteration rules convert between two scripts within a single language, but these rules will vary based on the glyphs that language's native script has, as well as how those glyphs correspond to pronunciation in that language. As such, transliteration can be thought of as a conversion from a source script to a target script in the context of a shared language (which can be notated as `s→t|l`, read as transliteration "from `s` to `t` given language `l`"). For a collection of n scripts and m languages, this gives n²-n possible script permutations in m possible contexts, for a total of m(n²-n) types of transliteration.
///
/// If limited to transliterations that involve at least one script that is not used natively by a language, this can be significantly lowered by requiring that all transliterations between two non-native scripts in a language's context to pass through that language's native script (`n_l`) first (`s→t|l` is equivalent to `s→n_l|l` followed by `n_l→t|l`). This requires only nm types of transliteration from `s` to `n_l` (since `n_l` is directly tied to l) and another nm types of transliterations from `n_l` to `t`, for a total of 2nm types of transliterations, a much more reasonably sized set of transliteration rules which need to exist than m(n²-n).
///
/// Once this constraint on transliteration paths is accepted, in its context the conversion to or from a native script (`s→n_l|l` or `n_l→t|l`) can be represented in a simplified form as `s→n_l` or `t→n_l`. Conversion which passes through a native script (`s→n_l|l + n_l→t|l = s→n_l + t→n_l`) can be represented in a simplified form as `s→n_l→t`.
///
/// Finally, note that in general, any one language has a single native script (though that script may be shared by multiple languages). This is not always true, as in the cases such as the Japanese language being written in katakana, hiragana, kanji, or rōmaji scripts, or Alethi being written in either Women's Script or Glyphs. However, for the purposes here, it is generally most useful, albeit technically inaccurate, to consider each of these to be native scripts for different languages (that is, there is no one native script for Japanese, but rather katakana is the native script for Katakana Japanese, hiragana the native script for Hiragana Japanese, etc.). In this way, any script can be identified by the name of a language for which it is a native script.
///
/// From the above, it is then evident that there are four possible cases in the conversion of `s→t|l`.
/// * The trivial case - if `s = t`, then the entire conversion is an identity function.
/// * Native source script - If `s` is the native script of `l`, `s→n_l` would be an identity function, and the full conversion would reduce to `s→t` with the language `l` being implicitly indicated by the language for which 's' is the native script.
/// * Native target script - If `t` is the native script of `l`, `n_l→t` would be an identity function, and the full conversion would reduce to `s→t` with the language `l` being implicitly indicated by the language for which 't' is the native script.
/// * Native source AND target script - If both `s` and `t` are the native script of `l`, then both `s→n_l` and `n_l→t` are identity functions, and the conversion `s→n_l→t` results in no changes (cases where spellings differ between languages, such as when English commonly spells loan words without their original diacritics, is, in the strictest sense, a case where two languages do _not_ share a common native script, and as such are not part of this case despite superficial resemblance).
///
/// Both the trivial case and the case where both `s` and `t` are native scripts of `l` are identity functions and can be ignored. Of the remaining two cases, a convention can be established such that any conversion `s→t` is always interpreted as being in the context of a language for which `s` is the native script, but `t` is not. Combined with the observation above around denoting a script by the name of a language for which it is native, this allows for the conversion to be specified via the name of two languages (for example, transliterating English's Latin script into the Alethi Women's Script script in the context of English can be described as a transliteration between English and Alethi).
mixin Script {
  /// Returns the name of the script corresponding to the generic type of this method when called.
  static String getName<L extends Script>() {
    switch (L) {
      case English:
        return 'English';
      case Alethi:
        return 'Alethi';
    }
    throw TypeError();
  }
}

/// A [Type] representing the Women's Script used in Alethi.
abstract class Alethi with Script {}

/// A [Type] representing the standard Latin script used in English.
abstract class English with Script {}
