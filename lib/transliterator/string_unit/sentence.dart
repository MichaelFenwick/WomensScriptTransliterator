part of womens_script_transliterator;

class Sentence extends StringUnit with Superunit<Word>, Subunit<Paragraph> {
  Sentence(String content) : super(content);

  @override
  final Pattern splitPattern = RegExp(r'.+?(\s+|$)');
}
