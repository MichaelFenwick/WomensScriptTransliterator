part of womens_script_transliterator;

class TextBlock extends StringUnit with Superunit<Paragraph> {
  TextBlock(String content) : super(content);

  @override
  final Pattern splitPattern = RegExp(r'.+?(\n?\r?\n|$)');
}
