part of transliterator;

abstract class StringUnit {
  final String content;
  final bool isComplete;

  StringUnit(this.content, {required this.isComplete});

  factory StringUnit.build(Type U, String content, {required bool isComplete}) {
    switch (U) {
      case TextBlock:
        return TextBlock(content, isComplete: isComplete);
      case Paragraph:
        return Paragraph(content, isComplete: isComplete);
      case Sentence:
        return Sentence(content, isComplete: isComplete);
      case Word:
        return Word(content, isComplete: isComplete);
      default:
        throw TypeError();
    }
  }

  //FIXME: This is terrible, since what it's really doing is returning the patternMatches for the Subunit of the type passed in. I need a better way to set it up so that I can run the patternMatches on the appropriate Regex without having to have an instance of the Subunit or a canonical Type for it.
  static bool matchesEndPattern(Type U, String content) {
    bool patternMatches(Pattern pattern, String string) => pattern.allMatches(string).isNotEmpty;

    switch (U) {
      case TextBlock:
        return patternMatches(RegExp(r'\n$'), content);
      case Paragraph:
        return patternMatches(RegExp('${Paragraph.requiredSentenceEndPunctuation}${Paragraph.optionalSentenceEndPunctuation}*\$'), content);
      case Sentence:
        return patternMatches(RegExp(r'[^\w\s]$'), content);
      default:
        return patternMatches(RegExp(r'$'), content);
    }
  }

  //FIXME: This doesn't work for passing in Subunit<U> generics.
  U cast<U extends StringUnit>() => StringUnit.build(U, content, isComplete: isComplete) as U;

  @override
  String toString() => content;
}
