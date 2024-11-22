part of womens_script_transliterator;

abstract class StructureTransliterator<E> extends Transliterator<E> {
  StructureTransliterator(
      {required Direction direction,
      Dictionary? dictionary,
      Mode mode = const Mode(),
      Writer outputWriter = const StdoutWriter(),
      Writer debugWriter = const StderrWriter()})
      : super(direction: direction, mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  @override
  FutureOr<ResultPair<E>> transliterate(E input, {bool useOutputWriter});

  @override
  Iterable<FutureOr<ResultPair<E>>> transliterateAll(Iterable<E> inputs, {bool useOutputWriter = false}) =>
      inputs.map((E input) => transliterate(input, useOutputWriter: useOutputWriter));
}
