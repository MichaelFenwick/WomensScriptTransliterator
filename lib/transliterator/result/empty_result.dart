part of womens_script_transliterator;

class EmptyResult<E, S extends Script, T extends Script> extends Result<E, S, T> {
  const EmptyResult(E sourceWord) : super(sourceWord);
}
