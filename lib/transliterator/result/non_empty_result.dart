part of womens_script_transliterator;

abstract class NonEmptyResult<E, I, S extends Script, T extends Script> extends Result<E, S, T> {
  final I target;

  const NonEmptyResult(E source, this.target) : super(source);

  static NonEmptyResult<E, dynamic, S, T> fromIterable<E, S extends Script, T extends Script>(E source, Iterable<E> targets) {
    switch (targets.length) {
      case 0:
        throw StateError(
            'A `NonEmptyResult` object can not be instantiated from an empty `Iterable`. Add a guard statement to ensure the `Iterable` has elements, or use the `Result.fromIterable<S, T>()` method instead.');
      case 1:
        return ResultPair<E, S, T>(source, targets.first);
      default:
        return ResultSet<E, S, T>.fromIterable(source, targets);
    }
  }
}
