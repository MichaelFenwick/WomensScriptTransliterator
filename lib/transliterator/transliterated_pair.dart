part of transliterator;

abstract class TransliteratedContainer<E, I, S extends Language, T extends Language> {
  final E source;
  final I target;

  const TransliteratedContainer(this.source, this.target);
}

abstract class TransliteratedSet<E, I extends Iterable<E>, S extends Language, T extends Language> extends TransliteratedContainer<E, I, S, T> {
  const TransliteratedSet(E source, I target) : super(source, target);
}

abstract class TransliteratedPair<E, S extends Language, T extends Language> extends TransliteratedContainer<E, E, S, T> {
  const TransliteratedPair(E source, E target) : super(source, target);
}
