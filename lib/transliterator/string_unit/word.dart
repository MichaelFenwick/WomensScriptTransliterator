part of transliterator;

class Word extends StringUnit with Subunit<Sentence> {
  Word(String content) : super(content);

  @override
  Pattern get splitPattern => '';
}
