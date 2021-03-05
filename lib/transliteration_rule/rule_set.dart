part of transliteration_rule;

class RuleSet<S extends Language, T extends Language> extends IterableBase<Rule<S, T>> {
  final Iterable<Rule<S, T>> _wordRules;

  const RuleSet(this._wordRules);

  @override
  Iterator<Rule<S, T>> get iterator => _wordRules.iterator;

  static RuleSet<S, T> getRuleSet<S extends Language, T extends Language>() {
    final RuleSet<Language, Language>? ruleSet = ruleSets[Direction(S, T)];
    if (ruleSet != null) {
      return ruleSet as RuleSet<S, T>;
    }

    throw TypeError();
  }

  static Map<Direction, RuleSet<Language, Language>> ruleSets = <Direction, RuleSet<Language, Language>>{
    Direction.english2Alethi: english2AlethiRuleSet,
    Direction.alethi2english: alethi2EnglishRuleSet,
  };
}
