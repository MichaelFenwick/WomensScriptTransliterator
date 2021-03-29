part of transliterator;

//TODO: Make a JsonTransliterator subclass of this.
//TODO: Make a way for the various StructureTransliterator subclasses to accept additional injected parameters, such as the filepath/name to save an epub to for the EpubTransliterator, or white/blacklists of tags for the XmlTransliterator. Might be best to make this very generic, with a StructureTransliteratorOptions interface which each StructureTransliterator can subclass to define the types of things they need.
abstract class StructureTransliterator<E, S extends Language, T extends Language> extends Transliterator<E, S, T> {
  StructureTransliterator({Dictionary<S, T>? dictionary, Writer outputWriter = const StdoutWriter(), Writer debugWriter = const StderrWriter()})
      : super(mode: const Mode(), dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  @override
  FutureOr<ResultPair<E, S, T>> transliterate(E input, {bool useOutputWriter});

  @override
  Iterable<FutureOr<ResultPair<E, S, T>>> transliterateAll(Iterable<E> inputs, {bool useOutputWriter = false}) =>
      inputs.map((E input) => transliterate(input, useOutputWriter: useOutputWriter));
}
