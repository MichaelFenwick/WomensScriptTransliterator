part of transliterator;

mixin Superunit<S extends StringUnit> implements StringUnit {
  abstract final Pattern splitPattern;
  abstract final Pattern? optionalSplitPatternEnding;

  Iterable<Match> splitIntoSubunits() => splitPattern.allMatches(content);
}
