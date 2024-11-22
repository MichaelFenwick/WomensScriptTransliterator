part of womens_script_transliterator;

class TextBlockTransliterator extends StringTransliterator<TextBlock> with SuperUnitStringTransliterator<TextBlock> {
  TextBlockTransliterator({
    required super.direction,
    Mode mode = const Mode(),
    Dictionary? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  TextBlockTransliterator.fromTransliterator(Transliterator<dynamic> transliterator)
      : super(
          direction: transliterator.direction,
          mode: transliterator.mode,
          dictionary: transliterator.dictionary,
          outputWriter: transliterator.outputWriter,
          debugWriter: transliterator.debugWriter,
        );

  @override
  ParagraphTransliterator getSubtransliterator() => ParagraphTransliterator.fromTransliterator(this);

  @override
  TextBlock buildUnit(String string) => TextBlock(string);
}
