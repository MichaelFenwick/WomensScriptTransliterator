part of transliterator;

abstract class Transliterator<E, S extends Language, T extends Language> {
  final Mode mode;
  late final Dictionary<S, T> dictionary;
  final Writer outputWriter;
  final Writer debugWriter;

  Transliterator({this.mode = const Mode(), Dictionary<S, T>? dictionary, this.outputWriter = const StdoutWriter(), this.debugWriter = const StderrWriter()}) {
    this.dictionary = dictionary ?? TempDictionary<S, T>();
  }

  FutureOr<Result<E, S, T>> transliterate(E input, {bool useOutputWriter});

  Iterable<FutureOr<Result<E, S, T>>> transliterateAll(Iterable<E> inputs, {bool useOutputWriter = false}) =>
      inputs.map((E input) => transliterate(input, useOutputWriter: useOutputWriter));
}
