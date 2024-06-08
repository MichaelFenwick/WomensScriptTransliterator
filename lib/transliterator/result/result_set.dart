part of womens_script_transliterator;

class ResultSet<E, S extends Language, T extends Language> extends NonEmptyResult<E, LinkedHashSet<E>, S, T> {
  ResultSet(E source, LinkedHashSet<E> targets)
      : assert(targets.isNotEmpty, 'At least one transliteration must be provided. Use `EmptyResult` to represent a Result with no transliterations.'),
        super(source, targets);

  ResultSet.fromIterable(E sourceWord, Iterable<E> transliterations) : this(sourceWord, transliterations = LinkedHashSet<E>.of(transliterations));

  @override
  String toString() => '[$source => ${target.join(',')}]';
}
