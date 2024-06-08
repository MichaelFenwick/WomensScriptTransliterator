part of womens_script_transliterator;

class TextBlockTransliterator<S extends Language, T extends Language> extends StringTransliterator<TextBlock, S, T>
    with SuperUnitStringTransliterator<TextBlock, S, T> {
  TextBlockTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static TextBlockTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      TextBlockTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  ParagraphTransliterator<S, T> getSubtransliterator() => ParagraphTransliterator.fromTransliterator<S, T>(this);

  @override
  TextBlock buildUnit(String string) => TextBlock(string);
}
