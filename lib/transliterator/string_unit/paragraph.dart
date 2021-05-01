part of transliterator;

class Paragraph extends StringUnit with Superunit<Sentence>, Subunit<TextBlock> {
  Paragraph(String content, {bool isComplete = true}) : super(content, isComplete: isComplete);

  static const String optionalSentenceEndPunctuation = r'[…—.!?"”\)\]\}]';
  static const String requiredSentenceEndPunctuation = '[.!?]';

  @override
  final Pattern splitPattern = RegExp('(.*?' // A sentence is a bit of text)'
      r'(?<![ .]\w)' // which doesn't end with only a single letter preceded by a period or whitespace,
      '$requiredSentenceEndPunctuation' // which has one of these required sentence ending punctuation marks
      '$optionalSentenceEndPunctuation*' // and is optionally followed by one or more of these punctuation marks
      r'\s+' // and then followed by one or more whitespace character
      '|' // or
      r'.+$)'); // anything leftover at the end of the string

  @override
  final Pattern optionalSplitPatternEnding = RegExp(optionalSentenceEndPunctuation + r'+\s*');
}
