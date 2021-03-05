part of transliterator;

class ResultPair<E, S extends Language, T extends Language> extends NonEmptyResult<E, E, S, T> {
  const ResultPair(E source, E target) : super(source, target);

  @override
  String toString() => '[$source => $target]';
}
