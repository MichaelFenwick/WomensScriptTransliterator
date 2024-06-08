part of womens_script_transliterator;

class OptionSet<S extends Script, T extends Script> extends ResultSet<String, S, T> {
  OptionSet(super.source, super.targets) : super.fromIterable();
}
