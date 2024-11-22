part of womens_script_transliterator;

/// A Dictionary is a collection mapping words from a source [Script] [S] to a target Script [T]. Accessing a Dictionary can be performed in place of transliterating a word via application of [Rule]s to improve transliteration performance. This class extends MapBase as a way to minimize the number of methods its subclasses need to override (for example, a Dictionary which needs special logic around adding or updating values can override the [Map.[]=] operator only, instead of also having to override methods like [Map.update], [Map.addAll], [Map.putIfAbsent], etc.
abstract class Dictionary extends MapBase<String, String> {
  /// Internal [HashMap] containing the [Dictionary]'s entries.
  late final HashMap<String, String> _hashmap;

  late final Direction _direction;

  Dictionary({required Direction direction, HashMap<String, String>? hashmap}) {
    _direction = direction;
    _hashmap = hashmap ?? HashMap<String, String>();
  }

  /// Builds a new [TempDictionary] containing all entries found in the source [dictionaries]. As a [Dictionary] can only contain one entry for any given key, should multiple elements of [dictionaries] contain entries with conflicting keys, the elements later in the [dictionaries] [Iterable] will be used instead of the entries from earlier elements.
  static TempDictionary union(Direction direction, Iterable<Dictionary> dictionaries) {
    final TempDictionary combinedDictionary = TempDictionary(direction);

    dictionaries.where((Dictionary dictionary) => dictionary._direction == direction).forEach(combinedDictionary.addAll);

    return combinedDictionary;
  }

  @override
  void operator []=(String key, String value) => _hashmap[key] = value;

  @override
  String? operator [](Object? key) => _hashmap[key];

  @override
  void clear() => _hashmap.clear();

  @override
  Iterable<String> get keys => _hashmap.keys;

  @override
  String? remove(Object? key) => _hashmap.remove(key);

  /// Parses [data] into a collection of dictionary entries. The string needs to be formatted such that each entry is separated by a newline (\n) character. For each entry line, that line may consist of either a single word in isolation (representing a word that is the same in both the source and target [Script]), or must contain two strings separated by a single tab (\t) character, representing a word with a spelling in the source Script of the first string, and a spelling in the target Script of the second string. Empty lines are ignored. If a input contains multiple lines with identical first words, the latest such entry will be the only one that will remain in the returned value.
  static HashMap<String, String> parseEntriesFromString(String data) =>
      HashMap<String, String>.fromEntries(RegExp(r'[^\n]+').allMatches(data).map<MapEntry<String, String>?>((Match lineMatch) {
        final String line = lineMatch[0]!;

        final List<String> lineParts = line.split('\t');
        switch (lineParts.length) {
          case 0:
            return null;
          case 1:
            return MapEntry<String, String>(lineParts[0], lineParts[0]);
          case 2:
            return MapEntry<String, String>(lineParts[0], lineParts[1]);
          default:
            throw FormatException(
                'The following line encountered when reading dictionary data does not contain one or two words separated by a tab as expected:\n$line');
        }
      }).whereType<MapEntry<String, String>>());
}
