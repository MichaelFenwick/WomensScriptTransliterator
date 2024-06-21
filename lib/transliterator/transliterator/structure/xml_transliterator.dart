part of womens_script_transliterator;

class XmlTransliterator<S extends Script, T extends Script> extends StructureTransliterator<XmlDocument, S, T> {
  XmlTransliterator({
    super.dictionary,
    super.mode = const Mode(),
    super.outputWriter = const StdoutWriter(),
    super.debugWriter = const StderrWriter(),
  });

  static XmlTransliterator<S, T> fromTransliterator<S extends Script, T extends Script>(Transliterator<dynamic, S, T> transliterator) =>
      XmlTransliterator<S, T>(
        dictionary: transliterator.dictionary,
        mode: transliterator.mode,
        outputWriter: transliterator.outputWriter,
        debugWriter: transliterator.debugWriter,
      );

  @override
  ResultPair<XmlDocument, S, T> transliterate(XmlDocument input, {bool useOutputWriter = false}) {
    // The XML will be modified in place, so make a copy of it for modification so as to not cause side effects on the input.
    final XmlDocument output = input.copy();
    final TextBlockTransliterator<S, T> textBlockTransliterator = TextBlockTransliterator.fromTransliterator(this);

    output.descendants // This will be all XmlNodes in the entire document, at all levels of nesting.
        // Only process the nodes that are XmlElements (i.e. ignore any XmlAttributes, which don't need to be processed, and XmlTexts, which will get processed further on once the XmlElements of interest are isolated first).
        .whereType<XmlElement>()
        // Only process the elements that might contain full paragraphs and sentences (i.e. not things like spans which generally are only there to stylize specific words in a sentence).
        .where(isBlockElement)
        // Block elements might be nested within one another (for example, paragraphs inside of a section/chapter div). In order to prevent their contents from being processed multiple times, ignore any elements that contain other block elements (i.e. get rid of any elements that aren't a leaf on the node tree). This might cause problems if something is formatted in such a way that a block element has primary text AND another block element inside it, but we just have to hope that no one is formatting their xml files so terribly. //TODO: Maybe this could be better done by filtering away XmlElements that don't contain any XmlTexts. I'm not sure how well that will alleviate the woes encountered with epubs such as Edgedancer, and I'm not sure the result is really any better anyway in the case of weirdly formatted documents. Maybe something where each block element's XmlText and XmlElement children get processed as their textBlock in the case where both exist?
        .where((XmlElement element) => !element.descendantElements.any(isBlockElement))
        // Run each of these block elements through the textBlockTransliterator
        .forEach((XmlElement element) => textBlockTransliterator
            .transliterateAtoms<XmlText>(breakElementIntoAtoms(element))
            // Only continue to process the contents of elements which can be transliterated into a ResultPair (an EmptyResult doesn't need replacing and replacing with a ResultSet doesn't make sense as an operation).
            .whereType<ResultPair<Atom<TextBlock, XmlText>, S, T>>()
            // Replace each XmlText with its transliterated content.
            .forEach((ResultPair<Atom<TextBlock, XmlText>, S, T> result) => result.target.context.replace(XmlText(result.target.content.content))));
    return ResultPair<XmlDocument, S, T>(input, output);
  }

  /// Returns true if the [XmlElement] passed is a block element (any of the HTML tags which are generally used to hold blocks of text like paragraphs or sentences, as opposed to tags like <span> which are generally used to style text or tags like <body> which are generally used as high level containers or semantic indicators).
  static bool isBlockElement(XmlElement element) => <String>['p', 'div', 'text', 'li'].contains(element.name.local);

  /// An [XmlElement] will contain some block of text which may be broken into multiple sections, for example by the presence of <span> or other such tags. This method will transform each of these sections of text into an [Iterable] of [Atom]s so that the transliterator can process them as a cohesive [TextBlock] while still replacing each section's text with the appropriate section of transliterated text.
  static Iterable<Atom<TextBlock, XmlText>> breakElementIntoAtoms(XmlElement element) => element.descendants
      // An XmlElement (which is a full XML tag like <div> or <span>, from opening to closing), contains a mixture of other XmlElements, XmlAttributes (which are the attributes for each tag), and XmlTexts (which are the text content of each element). Because element.descendants will return all of these, recursively, the full textual content of any XmlElement will be the XmlTexts within the result of element.descendants. Because only the textual content should be transliterated, the first step is to filter down to only those items.
      .whereType<XmlText>()
      // Wrap all the remaining XmlTexts in Atoms so they can be fed into the transliterator.
      .map((XmlText text) => Atom<TextBlock, XmlText>(
          TextBlock(text.value
              //FIXME: This is a fine place to execute logic (it needs to happen before the text gets to the SentenceTransliterator, otherwise a final period in the ellipsis might be moved to the sentence's start [see https://github.com/MichaelFenwick/WomensScriptTransliterator/issues/29]). However, this is pretty sloppily shoehorned in and should be pulled into its own method. Perhaps it could be better placed in ParagraphTransliterator.transliterateAtoms(). However, the EpubHtmlFileTransliterator transliterates titles by calling SentenceTransliterator directly, so maybe the logic should go there, with something passed into that transliterator to indicate that it should be executed because the sentence isn't a proper sentence. Ellipses are a tricky thing, because in theory they should exist alongside any sentence ending punctuation, but in practice, text may omit a period on a sentence that ends with an ellipsis.
              // Replace any poorly formatted ellipsis attempts to an actual ellipsis character.
              .replaceAll(RegExp(r'\.((&(nbsp|#0*160|#0x0*A0);| )?\.){2,4}'), Unicode.ellipsis)
              // And replace any leftover encoded nbsp characters with the actual character
              .replaceAll(RegExp('&nbsp;'), Unicode.nonBreakingSpace)),
          text));
}
