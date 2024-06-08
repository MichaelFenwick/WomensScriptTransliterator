part of womens_script_transliterator;

class ResultSet<E, S extends Script, T extends Script> extends NonEmptyResult<E, LinkedHashSet<E>, S, T> {
  ResultSet(E source, LinkedHashSet<E> targets)
      : assert(targets.isNotEmpty, 'At least one target must be provided. Use `EmptyResult` to represent a Result with no targets.'),
        super(source, targets);

  ResultSet.fromIterable(E sourceWord, Iterable<E> targets) : this(sourceWord, targets = LinkedHashSet<E>.of(targets));

  /// Creates a new NonEmptyResult with the same [source] as this, but whose [target] is different value.
  @override
  ResultSet<E, S, T> withNewTarget(Iterable<E> newTarget) => ResultSet<E, S, T>(source, LinkedHashSet<E>.of(newTarget));

  @override
  String toString() => '[$source => ${target.join(',')}]';
}
