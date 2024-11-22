part of womens_script_transliterator;

/// A [FileDictionary] is a [Dictionary] which is persisted to disk between executions. When constructed, the FileDictionary is pre-populated with the entries present in the dictionary file corresponding to the name provided in the constructor.
///
/// The [isUpdatable] flag specifies whether the FileDictionary's file should be used in a read-only mode, or if entries in the dictionary file can be changed. This flag only affects the backing file - even if the flag is set to false, calling a method to add a new entry will still add that entry to that instance's backing [Map]. If the flag is set to true, then adding a new entry will immediately write that entry to the backing file. This can potentially be unperformant if many new entries are added in succession, but due to the nature of a FileDictionary's persistence, fewer updates should be needed over time, and as a result, this lack of performance should be of minimal impact in normal usage.
///
/// The backing file will be in tsv format with one entry per line. For each entry, the word in the source [Script] [S] will be given first, with the word in the target Script [T] following after a tab character. Alternatively, a line may contain only one word with no tab characters, which would indicate that the word is identical in both the source and target Scripts (this tends to be the case for most words, and as such, specifying this type of word in this way makes the file significantly smaller).
class FileDictionary extends Dictionary {
  /// A flag to indicate whether or the FileDictionary's backing file can be updated, or if it should be used in read-only mode.
  final bool isUpdatable;

  /// The file used to back this FileDictionary.
  late File _dictionaryFile;

  /// Directory where named Dictionary files are stored.
  static const String dictionaryDirectory = 'data/dictionaries';

  FileDictionary(Direction direction, {required File file, this.isUpdatable = false})
      : super(direction: direction, hashmap: Dictionary.parseEntriesFromString(file.readAsStringSync()));

  /// Instantiate a FileDictionary backed by a named dictionary. Named dictionaries are stored in the [dictionaryDirectory] in a file with the corresponding name.
  FileDictionary.fromName(Direction direction, {required String name, bool isUpdatable = false})
      : this(direction, file: File('$dictionaryDirectory/${direction.source.getName()}2${direction.target.getName()}/$name'), isUpdatable: isUpdatable);

  /// Sets an entry's value in the [FileDictionary]. If [isUpdatable] is set to false, then this will only update the entry in memory but will not alter the backing file. Otherwise, a new line will be written to the backing file.
  @override
  void operator []=(String key, String value) {
    // Regardless of if the file is updated, the Dictionary instance's data should be updated in case this key is encountered again.
    _hashmap[key] = value;

    // If the Dictionary is not in read-only mode, then add the entry to the backing File as well.
    if (isUpdatable) {
      _updateFile(key, value);
    }
  }

  /// Adds the entry to the end of the backing file, regardless of if the entry is already present. In situations where the the entry is already present, this results in multiple entries for a given word to be in the file. As a consequence to how the file is read in the [_initialize] method, only the last copy of an entry will be used, giving a net result of an "update," albeit in a somewhat inefficient manner (it's assumed that the cost of reading multiple entries for a word will be less overhead overall than the cost of having to scan the entire file to find the appropriate file line to change would be).
  void _updateFile(String sourceWord, String transliteration) =>
      _dictionaryFile.writeAsStringSync('$sourceWord\t$transliteration\n', mode: FileMode.writeOnlyAppend);
}
