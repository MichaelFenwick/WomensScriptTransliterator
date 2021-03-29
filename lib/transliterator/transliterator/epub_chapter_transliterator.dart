part of transliterator;

class EpubChapterTransliterator<S extends Language, T extends Language> extends StructureTransliterator<File, S, T> {
  EpubChapterTransliterator({
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static EpubChapterTransliterator<S, T> fromTransliterator<S extends Language, T extends Language>(Transliterator<dynamic, S, T> transliterator) =>
      EpubChapterTransliterator<S, T>(
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Future<ResultPair<File, S, T>> transliterate(File input, {bool useOutputWriter = false}) async {
    final XmlDocument xml = XmlDocument.parse(await input.readAsString());

    final XmlTransliterator<S, T> xmlTransliterator = XmlTransliterator.fromTransliterator<S, T>(this);
    final ResultPair<XmlDocument, S, T> result = xmlTransliterator.transliterate(xml);

    await input.writeAsString(result.target.toXmlString());

    return ResultPair<File, S, T>(input, input);
  }
}
