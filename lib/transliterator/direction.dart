part of transliterator;

class Direction {
  final Type source;
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
