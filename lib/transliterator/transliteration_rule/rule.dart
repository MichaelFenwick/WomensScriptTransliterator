part of womens_script_transliterator;

/// A Rule represents the ways in which some set of characters can potentially be transliterated from the source [Script] [S] to the target Script [T]. A rule's specification describes the [Pattern]s that should be used to determine whether or not the rule is applicable to a certain set of characters, the [Position](s) in the word where it should be applied (some rules, for example, should only be applied at the start of a word but not elsewhere within it), and an [OptionSet] which specifies the potential text replacements which can be made for the matched characters.
///
/// Rules use [Pattern]s to identify whether or not it should be applied to a set of characters. As a consequence of this, a Rule that specifies multiple Patterns can potentially be applied to a variety of different characters. Technically, a single Pattern is capable of representing the same matching as multiple Patterns, for instance by joining the multiple Patterns by a `|`. By allowing multiple Patterns to specified rather than just one, no functionality is added, but the Patterns can be made more readable. For example, a Rule meant to target words where a `ci` is phonetically equivalent to `sh` could be specified with a single Pattern of `'ci(a(b|l)|(a|e|o)n|ious)'`, but it is easier to see the potential places where it can be applied if instead a [List] of Patterns of `['ciab', 'cial', 'cian', 'cien', 'cion', 'cious']` is given.
///
/// The characters that will be replaced by the application of a Rule is NOT affected by the number of characters that are consumed in evaluating the Pattern(s), but is instead given by the [OptionSet.source] of the specified [OptionSet]s. Each of these OptionSets acts as instructions to replace the characters provided by the [OptionSet.source] with one of the sets of characters provided by the [OptionSet.target]. The [OptionSet.source] should be defined so that the characters specified in it always exist in any word which is matched by the Rule's Pattern[s]. It should also contain the maximum number of characters as can be guaranteed to exist, as this source is meant to be used as a signal of which characters have been "handled" by the Rule, and each character consumed by the Rule in this manner reduces the number of characters that have to be evaluated in further iterations. For example, a Rule to transliterate the English character sequence `scious` into Alethi should specify an `OptionSet('scious', ['>ous'])` rather than `OptionSet('sci', ['>'])`, as the former allows the transliteration to skip past the `ous` after application of the Rule, even though those letters aren't actually changed by the Rule's application.
///
/// As transliteration is not perfectly deterministic, each [OptionSet.target] will generally specify multiple potential replacements for a given source representing all the logically consistent possible replacements, no matter how unlikely that replacement might be. In this case, the targets should be provided in order of a best estimate of likelihood of correctness, with the most likely replacement listed first. Further, Rules may specify multiple OptionSets, e.g. one to replace only the first character of a digraph and another to replace both characters. These too should be ordered such that the most likely correct OptionSet is first.
///
/// Rules are not evaluated against an entire word, but rather against a substring of a word starting at some character index through the end of the word. Each [OptionSet.source] must be a set of `n` characters that is expected to be found starting at that index (i.e., a Rule evaluated at index `i` can only replace characters `i` through `i+n` of a word, but can not replace characters `i+x` through `i+x+n` for an arbitrary `x`). Nonetheless, it is possible to create a Rule which places constraints on characters preceding the ones the Rule intends to replace by using positive or negative lookbehinds in the Rule's Pattern(s). Lookaheads are also allowed, but generally unnecessary (though negative lookaheads may be useful). These lookbehinds work because while the Rule is evaluated at an index, the Patterns are matched against the entire word (to be technical, "evaluating a Rule at an index i for a word w" means that the one of the Patterns must match w, that that match must start at i, and that the characters to be replaced specified by each OptionSet must be found in w starting at i).
class Rule {
  /// A collection of [Pattern]s which, if matched by a word at a given index, indicate that the Rule should be applied to that word at that index. A Rule should be applied if ANY of its Patterns are matched. See the [Rule] class's documentation for more details on how these Patterns are used.
  final Iterable<Pattern> patterns;

  /// A [Set] of [Position]s which give constraints on whether the Rule can be applied to [Position.start], [Position.middle], or [Position.end] of a word. A Rule will only be applied if the [Position] where it would be applied is a member of this Set. Because the roles letters play (and their pronunciations) can be highly dependant upon their placement in a word (for example, the letter X's pronunciation is almost entirely dependant upon whether it occurs at the start of a word or not), this allows a Rule to be given a scope that is appropriately limited without adding complexity to the Rule's [patterns]. A Rule is considered to be applied at [Position.start] if the Pattern's match is at index 0 of the word. It is considered to be applied at [Position.end] if the Pattern's match starts at index `word.length - match.length` (i.e., the match ends at the end of the word, rather than the match having to start at the word's final letter). If neither are true, then the Rule's application is considered to be at [Position.middle].
  final Set<Position> positions;

  /// A collection of [OptionSet]s which indicate which characters in the word should be replaced by this Rule (given by the [OptionSet.source]) and the possible values they might be replaced with (given by the [OptionSet.target]). Each possible replacement in the [OptionSet.target] should be provided in order of descending likelihood of being the correct transliteration, and all possible replacements, regardless of likelihood, should be provided. If multiple OptionSets are provided, each should have a unique [OptionSet.source]. See the [Rule] class's documentation for more details on how this OptionSet is used.
  final Iterable<OptionSet> options;

  /// A description of what the rule's targets and expected replacements are, written in plain English. This should also include any pertinent information detailing why the rule is needed, such as example words that are intended to be handled by it in the case of a rule that isn't generically applicable.
  final String description;

  const Rule(this.patterns, this.positions, this.options, this.description);

  /// Returns true if ANY one of this [Rule]'s [patterns] match the [input] string starting at position [cursor], and that match is located at a point which congruous with this [Rule]'s [positions] constraint.
  bool matches(String input, int cursor) => patterns.any((Pattern pattern) {
        final Match? match = pattern.matchAsPrefix(input, cursor);
        return match != null && positions.contains(_getPositionForMatch(input, match));
      });

  /// Returns the [Position] of a given [match] within an [input] string. If the [match] exists at both the start and end of the [input] (that is, the [match] spans the entire [input] then [Position.start] is returned.
  Position _getPositionForMatch(String input, Match match) {
    if (match.start == 0) {
      return Position.start;
    }
    if (match.end == input.length) {
      return Position.end;
    }

    return Position.middle;
  }
}
