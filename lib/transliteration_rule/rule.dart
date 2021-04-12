part of transliteration_rule;

class Rule<S extends Language, T extends Language> {
  final Iterable<Pattern> patterns;
  final Set<Position> positions;
  final Iterable<OptionSet<S, T>> options;
  final String description;

  const Rule(this.patterns, this.positions, this.options, this.description);

  /// Returns true if one of this [Rule]'s [patterns] match the [input] string starting at position [cursor], and that match is located at a point which congruous with this [Rule]'s [positions] constraint.
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
