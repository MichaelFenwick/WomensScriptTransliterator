part of womens_script_transliterator;

abstract class StringUnit {
  final String content;
  abstract final Pattern splitPattern;

  StringUnit(this.content);

  Iterable<Match> splitIntoSubunits() => splitPattern.allMatches(content);

  factory StringUnit.build(Type U, String content) {
    switch (U) {
      case TextBlock:
        return TextBlock(content);
      case Paragraph:
        return Paragraph(content);
      case Sentence:
        return Sentence(content);
      case Word:
        return Word(content);
      default:
        throw TypeError();
    }
  }

  //FIXME: This doesn't work for passing in Subunit<U> generics.
  U cast<U extends StringUnit>() => StringUnit.build(U, content) as U;

  @override
  String toString() => content;
}
