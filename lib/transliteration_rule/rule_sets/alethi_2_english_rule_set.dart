part of transliteration_rule;

//TODO: Fill this with the appropriate rules
RuleSet<Alethi, English> alethi2EnglishRuleSet = RuleSet<Alethi, English>(<Rule<Alethi, English>>[
  Rule<Alethi, English>(
    <String>[''],
    anywhere,
    ResultSet<String, Alethi, English>.fromIterable('', <String>['']),
    '',
  ),
]);
