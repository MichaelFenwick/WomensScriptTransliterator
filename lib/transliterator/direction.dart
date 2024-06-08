part of womens_script_transliterator;

/// Represents the concept of a transliteration from a [source] [Script] to a [target] Script.
class Direction {
  /// The Type of the [Script] subclass which represents the transliteration source script.
  final Type source;

  /// The Type of the [Script] subclass which represents the transliteration target script.
  final Type target;

  const Direction(this.source, this.target);

  static const Direction english2Alethi = Direction(English, Alethi);
  static const Direction alethi2english = Direction(Alethi, English);

  @override
  bool operator ==(Object other) => other is Direction && source == other.source && target == other.target;

  @override
  int get hashCode => source.hashCode + target.hashCode;

  @override
  String toString() => 'Source: $source, target $target';
}
