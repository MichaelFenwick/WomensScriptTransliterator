part of transliterator;

class Word extends StringUnit with Subunit<Sentence> {
  Word(String content, {bool isComplete = true}) : super(content, isComplete: isComplete);
}
