part of transliterator;

class Sentence extends StringUnit with Superunit<Word>, Subunit<Paragraph> {
  Sentence(String content, {bool isComplete = true}) : super(content, isComplete: isComplete);

  @override
  final Pattern splitPattern = RegExp(r'.+?(\s|$)');
}
