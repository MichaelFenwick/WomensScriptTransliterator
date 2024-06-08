part of womens_script_transliterator;

class EmptyResult<E, S extends Language, T extends Language> extends Result<E, S, T> {
  const EmptyResult(E sourceWord) : super(sourceWord);
}
