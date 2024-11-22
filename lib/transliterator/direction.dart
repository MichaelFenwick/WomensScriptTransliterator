part of womens_script_transliterator;

/// Represents the concept of a transliteration from a [source] [Script] to a [target] Script.
class Direction {
  /// The [Script] const which represents the transliteration source script.
  final Script source;

  /// The [Script] const which represents the transliteration target script.
  final Script target;

  const Direction(this.source, this.target);

  static const Direction english2Alethi = Direction(Script.english, Script.alethi);
  static const Direction alethi2english = Direction(Script.alethi, Script.english);

  @override
  bool operator ==(Object other) => other is Direction && source == other.source && target == other.target;

  @override
  int get hashCode => source.hashCode + target.hashCode;

  @override
  String toString() => 'Source: $source, target $target';
}
