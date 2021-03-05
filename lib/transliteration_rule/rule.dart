part of transliteration_rule;

class Rule<S extends Language, T extends Language> {
  final List<String> patterns;
  final Set<Position> positions;
  final ResultSet<String, S, T> options;
  final String description;

  // A list of patterns, where, if the string matches them, then the rule will not be applied. This is used to define exceptions to rules.
  final List<String> denyPatterns;

  const Rule(this.patterns, this.positions, this.options, this.description, {this.denyPatterns = const <String>[]});

  bool patternMatches(String prefixString, String postfixString) => patterns
      .any((String pattern) => pattern.matchAsPrefix(postfixString) != null && positions.contains(getPositionForMatch(prefixString, postfixString, pattern)));

  bool denyPatternMatchesString(String prefixString, String postfixString) => denyPatterns
      .any((String pattern) => pattern.matchAsPrefix(postfixString) != null && positions.contains(getPositionForMatch(prefixString, postfixString, pattern)));

  bool matches(String prefixString, String postfixString) =>
      patternMatches(prefixString, postfixString) && !denyPatternMatchesString(prefixString, postfixString);

  Position? getPositionForMatch(String prefixString, String postfixString, String pattern) {
    if (prefixString.isEmpty) {
      return Position.start;
    }
    if (prefixString.isNotEmpty && pattern.length < postfixString.length) {
      return Position.middle;
    }
    if (prefixString.length == pattern.length) {
      return Position.end;
    }

    return null;
  }
}
