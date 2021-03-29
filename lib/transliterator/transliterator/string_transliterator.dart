part of transliterator;

abstract class StringTransliterator<S extends Language, T extends Language> extends Transliterator<String, S, T> {
  StringTransliterator(
      {Mode mode = const Mode(), Dictionary<S, T>? dictionary, Writer outputWriter = const StdoutWriter(), Writer debugWriter = const StderrWriter()})
      : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);
}
