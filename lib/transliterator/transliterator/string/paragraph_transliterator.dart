part of transliterator;

class ParagraphTransliterator<S extends Language, T extends Language> extends StringTransliterator<Paragraph, S, T>
    with SuperUnitStringTransliterator<Paragraph, S, T> {
  ParagraphTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static ParagraphTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      ParagraphTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  SentenceTransliterator<S, T> getSubtransliterator() => SentenceTransliterator.fromTransliterator<S, T>(this);

  @override
  Paragraph buildUnit(String string, {required bool isComplete}) => Paragraph(string, isComplete: isComplete);
}
