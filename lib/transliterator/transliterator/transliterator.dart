part of womens_script_transliterator;

abstract class Transliterator<E> {
  Direction direction;
  Mode mode;
  late Dictionary dictionary;
  Writer outputWriter;
  Writer debugWriter;

  Transliterator(
      {required this.direction,
      this.mode = const Mode(),
      Dictionary? dictionary,
      this.outputWriter = const StdoutWriter(),
      this.debugWriter = const StderrWriter()}) {
    this.dictionary = dictionary ?? TempDictionary(direction);
  }

  FutureOr<Result<E>> transliterate(E input, {bool useOutputWriter});

  Iterable<FutureOr<Result<E>>> transliterateAll(Iterable<E> inputs, {bool useOutputWriter = false}) =>
      inputs.map((E input) => transliterate(input, useOutputWriter: useOutputWriter));
}
