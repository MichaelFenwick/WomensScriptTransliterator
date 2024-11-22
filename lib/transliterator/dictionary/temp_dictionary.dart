part of womens_script_transliterator;

/// A [TempDictionary] is one that exists purely in memory at runtime, and is discarded once execution completes. This is meant as a mechanism to memoize transliterations to improve performance during execution without having to commit those transliterations to a more persistent [Dictionary] subclass.
class TempDictionary extends Dictionary {
  TempDictionary(Direction direction) : super(direction: direction, hashmap: null);

  TempDictionary.fromDataString(Direction direction, String data) : super(direction: direction, hashmap: Dictionary.parseEntriesFromString(data));
}
