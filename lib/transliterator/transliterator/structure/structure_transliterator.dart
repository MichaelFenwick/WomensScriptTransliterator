part of womens_script_transliterator;

abstract class StructureTransliterator<E, S extends Language, T extends Language> extends Transliterator<E, S, T> {
  StructureTransliterator({Dictionary<S, T>? dictionary, Mode mode = const Mode(), Writer outputWriter = const StdoutWriter(), Writer debugWriter = const StderrWriter()})
      : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  @override
  FutureOr<ResultPair<E, S, T>> transliterate(E input, {bool useOutputWriter});

  @override
  Iterable<FutureOr<ResultPair<E, S, T>>> transliterateAll(Iterable<E> inputs, {bool useOutputWriter = false}) =>
      inputs.map((E input) => transliterate(input, useOutputWriter: useOutputWriter));
}
