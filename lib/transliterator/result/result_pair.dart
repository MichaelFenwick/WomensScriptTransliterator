part of womens_script_transliterator;

class ResultPair<E, S extends Script, T extends Script> extends NonEmptyResult<E, E, S, T> {
  const ResultPair(E source, E target) : super(source, target);

  const ResultPair.fromValue(E value) : super(value, value);

  /// Creates a new ResultPair with the same [source] as this, but whose [target] is different value.
  @override
  ResultPair<E, S, T> withNewTarget(E newTarget) => ResultPair<E, S, T>(source, newTarget);

  @override
  String toString() => '[$source => $target]';
}
