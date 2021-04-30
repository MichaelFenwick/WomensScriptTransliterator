part of transliterator;

/// A container which links a piece of [content] to the [context] from which it was taken. This allows the content to be processed, and then the processed values to be returned to the original context.
class Atom<E, X> {
  final E content;
  final X context;

  const Atom(this.content, this.context);

  /// Creates a new [Atom] like [this] one, but with different [content]. The [context] of the returned Atom remains unchanged.
  Atom<E, X> withNewContent(E content) => Atom<E, X>(content, context);

  @override
  String toString() => content.toString();
}
