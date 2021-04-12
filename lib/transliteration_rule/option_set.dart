part of transliteration_rule;

class OptionSet<S extends Language, T extends Language> extends ResultSet<String, S, T> {
  OptionSet(String source, Iterable<String> targets) : super.fromIterable(source, targets);
}
