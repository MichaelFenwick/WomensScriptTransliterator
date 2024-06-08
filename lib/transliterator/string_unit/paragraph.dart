part of womens_script_transliterator;

class Paragraph extends StringUnit with Superunit<Sentence>, Subunit<TextBlock> {
  Paragraph(String content) : super(content);

  static const String optionalSentenceEndPunctuation = r'[…—.!?"”\)\]\}]';
  static const String requiredSentenceEndPunctuation = '[.!?]';

  @override
  final Pattern splitPattern = RegExp('(.*?' // A sentence is a bit of text'
      r'(?<![ .]\w)' // which doesn't end with only a single letter preceded by a period or whitespace,
      '$requiredSentenceEndPunctuation' // which has one of these required sentence ending punctuation marks
      '$optionalSentenceEndPunctuation*' // and is optionally followed by one or more of these punctuation marks
      r'\s+' // and then followed by one or more whitespace character
      ')|(' // or
      r'\n' //just a line break without anything else
      ')|(' // or
      r'.+$)'); // anything leftover at the end of the string
}
