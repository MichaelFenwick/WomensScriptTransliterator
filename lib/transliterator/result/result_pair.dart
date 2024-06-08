part of womens_script_transliterator;

class ResultPair<E, S extends Script, T extends Script> extends NonEmptyResult<E, E, S, T> {
  const ResultPair(E source, E target) : super(source, target);

  const ResultPair.fromValue(E value) : super(value, value);

  @override
  String toString() => '[$source => $target]';
}
