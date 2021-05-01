part of transliterator;

mixin Superunit<S extends StringUnit> implements StringUnit {
  abstract final Pattern splitPattern;

  Iterable<Match> splitIntoSubunits() => splitPattern.allMatches(content);
}
