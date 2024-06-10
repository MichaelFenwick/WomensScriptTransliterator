part of womens_script_transliterator;

class ParagraphTransliterator<S extends Script, T extends Script> extends StringTransliterator<Paragraph, S, T>
    with SuperUnitStringTransliterator<Paragraph, S, T> {
  ParagraphTransliterator({
    Mode mode = const Mode(),
    Dictionary<S, T>? dictionary,
    Writer outputWriter = const StdoutWriter(),
    Writer debugWriter = const StderrWriter(),
  }) : super(mode: mode, dictionary: dictionary, outputWriter: outputWriter, debugWriter: debugWriter);

  static ParagraphTransliterator<S, T> fromTransliterator<S extends Script, T extends Script>(Transliterator<dynamic, S, T> transliterator) =>
      ParagraphTransliterator<S, T>(
        mode: transliterator.mode,
        dictionary: transliterator.dictionary,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  Iterable<Result<Atom<Paragraph, X>, S, T>?> transliterateAtoms<X>(Iterable<Atom<StringUnit, X>?> unitAtoms) {
    final String paragraphText = unitAtoms.map((Atom<StringUnit, X>? atom) => atom?.content.content).join();

    // Process any paragraphs whose contents only consist of non-alphabetical characters in a special manner (since transliteration should only be applied to words). By returning the result of this directly without calling super.transliterateAtoms(), the normal logic which recurses down the Unit hierarchy will be short-circuited and further processing prevented.
    //TODO: This is a very Latin-centric regex. In an ideal world, the regex being used would be based on the value of [S] so that it can properly detect which characters are used in words in the source Script.
    if (!paragraphText.contains(RegExp('[a-zA-Z]'))) {
      return processWordlessParagraphs(unitAtoms);
    }

    // Any paragraphs that have letters in them should be processed as normal. Pass them along to the super method which will break them into sentences and continue the transliteration at that Unit level.
    return super.transliterateAtoms(unitAtoms);
  }

  /// Application of special rules for transliterating any paragraphs which don't contain any words. Such paragraphs will frequently have symbolic glyphs meant as visual decoration rather than any semantic meaning, and this may not translate well if left unchanged. Alternatively, a wordless paragraph might simply have content which otherwise would be mangled in an undesirable manner should it be passed down to the [SentenceTransliterator] and [WordTransliterator]. While it is generally the case that these paragraphs only contain a single "word" or at most, a "sentence," it is important that this special behavior happen up at the [ParagraphTransliterator] level, because the behavior of lower level [StringTransliterator]s may prevent the desired result from being achieved (e.g., the [SentenceTransliterator] may attempt to add a leading period and/or remove a trailing period, despite these paragraphs not containing anything that is semantically a "sentence").
  Iterable<Result<Atom<Paragraph, X>, S, T>?> processWordlessParagraphs<X>(Iterable<Atom<StringUnit, X>?> unitAtoms) {
    final Iterable<Atom<StringUnit, X>> nonNullUnitAtoms = unitAtoms.whereType<Atom<StringUnit, X>>();
    final String paragraphText = nonNullUnitAtoms.map((Atom<StringUnit, X>? atom) => atom?.content.content).join();

    // Asterisks are often used as section breaks, but won't really display well in fonts like Women's Script. Convert them to underscores to get a nice looking line to separate the sections instead. A source really oughtn't break up such a section break across multiple Atoms, but in the event it does, the new section break will replace only the first Atom of the Paragraph, with the content of any subsequent Atoms being removed.
    // TODO: This logic only makes sense in the context of English to Alethi transliteration. In an ideal world, this type of replacement would exist somewhere in the TransliterationRule paradigm and thus its application would depend on the transliteration context.
    if (paragraphText.contains(RegExp(r'^\s*\*(\s*\*){2,4}\s*$'))) {
      final Atom<Paragraph, X> firstAtom = Atom<Paragraph, X>(Paragraph(nonNullUnitAtoms.first.content.content), nonNullUnitAtoms.first.context);
      return <Result<Atom<StringUnit, X>, S, T>>[
        ResultPair<Atom<StringUnit, X>, S, T>(firstAtom, firstAtom.withNewContent(Paragraph('__________'))),
        ...nonNullUnitAtoms.skip(1).map(EmptyResult<Atom<StringUnit, X>, S, T>.new)
      ].map<Result<Atom<Paragraph, X>, S, T>>(
          // Transform each Result into one of the proper type (a Result of Atoms of Paragraphs)
          (Result<Atom<StringUnit, X>, S, T> result) =>
              result.cast<Atom<Paragraph, X>>((Atom<StringUnit, X> atom) => Atom<Paragraph, X>(Paragraph(atom.content.content), atom.context)));
    }

    // If the content wasn't of a type which required unique changes, simply return Results in which the original content remains unchanged.
    return nonNullUnitAtoms.map<Result<Atom<Paragraph, X>, S, T>>(
        (Atom<StringUnit, X> atom) => ResultPair<Atom<Paragraph, X>, S, T>.fromValue(Atom<Paragraph, X>(Paragraph(atom.content.content), atom.context)));
  }

  @override
  SentenceTransliterator<S, T> getSubtransliterator() => SentenceTransliterator.fromTransliterator<S, T>(this);

  @override
  Paragraph buildUnit(String string) => Paragraph(string);
}
