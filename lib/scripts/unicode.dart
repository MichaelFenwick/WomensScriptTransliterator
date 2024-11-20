abstract class Unicode {
  /// A dash with a width equivalent to the 'm' character (as in a variable width Latin script font).
  static const String emDash = '\u2014';

  /// A character which displays as three period characters in a row (...), though the spacing between period characters may differ from how three consecutive periods would display.
  static const String ellipsis = '\u2026';

  /// A character which displays as a normal space, but which indicates that a line break should not occur between adjoining characters.
  static const String nonBreakingSpace = ' ';

  /// An invisible character used to indicate that a line break should not occur between adjoining characters. This character does not affect ligating and cursive joining behavior between adjoining characters.
  static const String wordJoiner = '⁠';

  /// An invisible character used to indicate that the characters on either side of it should not be joined with ligation or cursive joining.
  static const String zeroWidthNonJoiner = '\u200C';
}

//TODO: https://docs.oracle.com/cd/E29584_01/webhelp/mdex_basicDev/src/rbdv_chars_mapping.html is a good list of foreign characters and the best ascii mapping of them. Eventually I should make links in the font for all of these.
