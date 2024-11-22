part of womens_script_transliterator;

class ResultPair<E> extends NonEmptyResult<E, E> {
  const ResultPair(E source, E target) : super(source, target);

  const ResultPair.fromValue(E value) : super(value, value);

  /// Creates a new ResultPair with the same [source] as this, but whose [target] is different value.
  @override
  ResultPair<E> withNewTarget(E newTarget) => ResultPair<E>(source, newTarget);

  @override
  String toString() => '[$source => $target]';
}
