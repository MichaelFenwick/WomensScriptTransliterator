part of transliterator;

//TODO: Make subclasses for XML or JSON or whatever other structures I might find. These would likely need to be told what to expect the transliteratable fields to be, and what type of text would be in them, and then would forward the transliteration off to the other non-structured sub-classes for the actual transliteration.
abstract class Transliterator<E, S extends Language, T extends Language> {
  final Mode mode;
  late final Dictionary<S, T> dictionary;
  final Writer outputWriter;
  final Writer debugWriter;

  Transliterator({this.mode = const Mode(), Dictionary<S, T>? dictionary, this.outputWriter = const StdoutWriter(), this.debugWriter = const StderrWriter()}) {
    this.dictionary = dictionary ?? TempDictionary<S, T>();
  }

  Result<E, S, T> transliterate(E input, {bool useOutputWriter});

  Iterable<Result<E, S, T>> transliterateAll(Iterable<E> inputs, {bool useOutputWriter = true});
}

abstract class StringTransliterator<S extends Language, T extends Language> extends Transliterator<String, S, T> {
  StringTransliterator(
      {Mode mode = const Mode(), Dictionary<S, T>? dictionary, Writer outputWriter = const StdoutWriter(), Writer debugWriter = const StderrWriter()})
      : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  @override
  Iterable<Result<String, S, T>> transliterateAll(Iterable<String> inputs, {bool useOutputWriter = true}) =>
      inputs.map((String input) => transliterate(input, useOutputWriter: useOutputWriter));
}

abstract class StructureTransliterator<E, S extends Language, T extends Language> extends Transliterator<E, S, T> {}
