part of womens_script_transliterator;

/// A [TempDictionary] is one that exists purely in memory at runtime, and is discarded once execution completes. This is meant as a mechanism to memoize transliterations to improve performance during execution without having to commit those transliterations to a more persistent [Dictionary] subclass.
class TempDictionary<S extends Script, T extends Script> extends Dictionary<S, T> {
  TempDictionary() {
    _hashmap = HashMap<String, String>();
  }

  TempDictionary.fromDataString(String data) {
    _hashmap = parseEntriesFromString(data);
  }
}
