part of womens_script_transliterator;

abstract class NonEmptyResult<E, I> extends Result<E> {
  final I target;

  const NonEmptyResult(E source, this.target) : super(source);

  static NonEmptyResult<E, dynamic> fromIterable<E>(E source, Iterable<E> targets) {
    switch (targets.length) {
      case 0:
        throw StateError(
            'A `NonEmptyResult` object can not be instantiated from an empty `Iterable`. Add a guard statement to ensure the `Iterable` has elements, or use the `Result.fromIterable()` method instead.');
      case 1:
        return ResultPair<E>(source, targets.first);
      default:
        return ResultSet<E>.fromIterable(source, targets);
    }
  }

  /// Creates a new NonEmptyResult with the same [source] as this, but whose [target] is different value.
  NonEmptyResult<E, I> withNewTarget(I newTarget);
}
