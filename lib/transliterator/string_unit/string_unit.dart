part of transliterator;

abstract class StringUnit {
  final String content;
  final bool isComplete;

  //TODO: Do some research to see what characters can reasonably be expected to be the end of a sentence. Make sure to include things like fancy quotes (single and double) and other such variations.
  static const String optionalSentenceEndPunctuation = r'[…—.!?"”\)\]\}]';
  static const String requiredSentenceEndPunctuation = '[.!?]';

  StringUnit(this.content, {required this.isComplete});

  //FIXME: This is terrible, since what it's really doing is returning the patternMatches for the Subunit of the type passed in. I need a better way to set it up so that I can run the patternMatches on the appropriate Regex without having to have an instance of the Subunit or a canonical Type for it.
  static bool matchesEndPattern(Type U, String content) {
    bool patternMatches(Pattern pattern, String string) => pattern.allMatches(string).isNotEmpty;

    switch (U) {
      case TextBlock:
        return patternMatches(RegExp(r'\n$'), content);
      case Paragraph:
        return patternMatches(RegExp('$requiredSentenceEndPunctuation$optionalSentenceEndPunctuation*\$'), content);
      case Sentence:
        return patternMatches(RegExp(r'[^\w\s]$'), content);
      default:
        return patternMatches(RegExp(r'$'), content);
    }
  }

  //FIXME: This doesn't work for passing in Subunit<U> generics.
  U cast<U extends StringUnit>() {
    switch (U) {
      case TextBlock:
        return TextBlock(content, isComplete: isComplete) as U;
      case Paragraph:
        return Paragraph(content, isComplete: isComplete) as U;
      case Sentence:
        return Sentence(content, isComplete: isComplete) as U;
      case Word:
        return Word(content, isComplete: isComplete) as U;
      default:
        throw TypeError();
    }
  }

  @override
  String toString() => content;
}
