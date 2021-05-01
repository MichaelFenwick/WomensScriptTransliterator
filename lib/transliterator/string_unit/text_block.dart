part of transliterator;

class TextBlock extends StringUnit with Superunit<Paragraph> {
  TextBlock(String content, {bool isComplete = true}) : super(content, isComplete: isComplete);

  @override
  final Pattern splitPattern = RegExp(r'.+?(\n|$)');

  @override
  final Pattern? optionalSplitPatternEnding = null;
}
