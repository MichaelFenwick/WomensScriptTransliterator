part of womens_script_transliterator;

/// An [Iterable] of [Rule]s which comprise all the potential transformations that might be utilized in transliterating a word. To be transliterated, a word can have the Rules in the RuleSet applied to it. Depending on the intent in the transliteration, this process might involve having all Rules checked iteratively, with all the results compiled together to identify all possible transliterations. Alternatively, if only the most likely transliteration is required, then a word might only be checked until an applicable Rule is found. For this reason, the Rules should be specified in order of most to least likely to be correct, so that the first matched Rule is likely to to give a good result. For Rules which are mutually exclusive (and thus, are 0% likely in contexts where the others have a non-0 likelihood), these rules should be provided in order of most to least common (e.g. specifying a rule to handle `E` before a rule to handle `Z` or `Q`), in order to allow something processing the RuleSet to exit as early as possible.
class RuleSet<S extends Script, T extends Script> extends IterableBase<Rule<S, T>> {
  /// An internal Iterable this for which this class acts as a wrapper.
  final Iterable<Rule<S, T>> _wordRules;

  const RuleSet(this._wordRules);

  @override
  Iterator<Rule<S, T>> get iterator => _wordRules.iterator;

  /// For a given source [Script] [S] and target Script [T], returns the predefined [RuleSet] which corresponds to transliteration of a word from [S] to [T]. Throws a [TypeError] if the indicated Scripts do not have a corresponding RuleSet.
  static RuleSet<S, T> getRuleSet<S extends Script, T extends Script>() {
    final RuleSet<Script, Script>? ruleSet = ruleSets[Direction(S, T)];
    if (ruleSet != null) {
      return ruleSet as RuleSet<S, T>;
    }

    throw TypeError();
  }

  static Map<Direction, RuleSet<Script, Script>> ruleSets = <Direction, RuleSet<Script, Script>>{
    Direction.english2Alethi: english2AlethiRuleSet,
    Direction.alethi2english: alethi2EnglishRuleSet,
  };
}
