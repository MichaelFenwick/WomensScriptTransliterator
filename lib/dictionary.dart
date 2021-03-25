import 'dart:collection';
import 'dart:io';

import 'scripts/language.dart';
import 'transliterator.dart';

abstract class Dictionary<S extends Language, T extends Language> {
  late HashMap<String, String> entries;

  void update(ResultPair<String, S, T> result);
}

class TempDictionary<S extends Language, T extends Language> extends Dictionary<S, T> {
  TempDictionary() {
    entries = HashMap<String, String>();
  }

  @override
  void update(ResultPair<String, S, T> result) {
    entries[result.source] = result.target;
  }
}

class FileDictionary<S extends Language, T extends Language> extends Dictionary<S, T> {
  static const String dictionaryDirectory = 'data/dictionaries';
  final bool updatable;
  late File _dictionaryFile;

  FileDictionary({required String name, this.updatable = false}) {
    _dictionaryFile = File('$dictionaryDirectory/${Language.getName<S>()}2${Language.getName<T>()}/$name');
    _initialize();
  }

  void _initialize() {
    entries = HashMap<String, String>.fromEntries(_dictionaryFile.readAsLinesSync().map<MapEntry<String, String>>((String line) {
      if (line.isEmpty) {
        return const MapEntry<String, String>('', '');
      }
      final List<String> lineParts = line.split('\t');
      if (lineParts.length > 2) {
        throw UnsupportedError(
            'The following line encountered when reading dictionary file $_dictionaryFile does not contain one or two words separated by a tab as expected:\n$line');
      }
      if (lineParts.length == 1) {
        //if a transliteration isn't given on the line, then we take that to mean that the word's correct transliteration is the same as its source. Because this is the case for most words, doing this allows the dictionary file size to be significantly smaller.
        lineParts.add(lineParts[0]);
      }
      return MapEntry<String, String>(lineParts[0], lineParts[1]);
    }));
  }

  @override
  void update(ResultPair<String, S, T> result) {
    //regardless of if we actually update the file, update the Dictionary instance's data in case we see this word again
    entries[result.source] = result.target;

    if (updatable) {
      _update(result.source, result.target);
    }
  }

  void _update(String sourceWord, String transliteration) =>
      _dictionaryFile.writeAsStringSync('$sourceWord\t$transliteration\n', mode: FileMode.writeOnlyAppend);
}
