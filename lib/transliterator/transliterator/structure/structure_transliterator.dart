part of transliterator;

abstract class StructureTransliterator<E, S extends Language, T extends Language> extends Transliterator<E, S, T> {
  StructureTransliterator({Dictionary<S, T>? dictionary, Writer outputWriter = const StdoutWriter(), Writer debugWriter = const StderrWriter()})
      : super(mode: const Mode(), dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  @override
  FutureOr<ResultPair<E, S, T>> transliterate(E input, {bool useOutputWriter});

  @override
  Iterable<FutureOr<ResultPair<E, S, T>>> transliterateAll(Iterable<E> inputs, {bool useOutputWriter = false}) =>
      inputs.map((E input) => transliterate(input, useOutputWriter: useOutputWriter));
}
