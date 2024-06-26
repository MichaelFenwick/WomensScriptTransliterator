part of womens_script_transliterator;

abstract class Transliterator<E, S extends Script, T extends Script> {
  Mode mode;
  late Dictionary<S, T> dictionary;
  Writer outputWriter;
  Writer debugWriter;

  Transliterator({this.mode = const Mode(), Dictionary<S, T>? dictionary, this.outputWriter = const StdoutWriter(), this.debugWriter = const StderrWriter()}) {
    this.dictionary = dictionary ?? TempDictionary<S, T>();
  }

  FutureOr<Result<E, S, T>> transliterate(E input, {bool useOutputWriter});

  Iterable<FutureOr<Result<E, S, T>>> transliterateAll(Iterable<E> inputs, {bool useOutputWriter = false}) =>
      inputs.map((E input) => transliterate(input, useOutputWriter: useOutputWriter));
}
