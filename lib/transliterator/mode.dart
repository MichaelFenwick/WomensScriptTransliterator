part of womens_script_transliterator;

/// Used to define how a [Transliterator] should act in regards to multiple potential modes of operation.
class Mode {
  /// When a word is not found in a predefined [Dictionary] and needs to be transliterated using a [RuleSet], this option will make the transliteration return a [ResultPair] with the RuleSet's best guess rather than a [ResultSet] with all possible transliterations.
  final bool algorithmBestOptionOnly;

  /// Indicates that the [Transliterator] should treat its contents as a fragment (i.e. not a complete sentence or the like) and as such, shouldn't be processed in the normal way (e.g., it shouldn't be prefixed with a leading period).
  final bool treatAsFragment;

  const Mode({this.algorithmBestOptionOnly = true, this.treatAsFragment = false});
}
