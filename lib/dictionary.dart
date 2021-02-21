import 'dart:collection';
import 'dart:io';

import 'language.dart';
import 'transliteration.dart';

class Dictionary<S extends Language, T extends Language> {
  static const String dictionaryDirectory = 'data/dictionaries';
  final bool updatable;
  late File dictionaryFile;
  late HashMap<String, String> entries;

  Dictionary({required String name, this.updatable = false}) {
    dictionaryFile = File('$dictionaryDirectory/${Language.getName<S>()}2${Language.getName<T>()}/$name');
    _initialize();
  }

  void _initialize() {
    entries = HashMap<String, String>.fromEntries(dictionaryFile.readAsLinesSync().map<MapEntry<String, String>>((String line) {
      if (line.isEmpty) {
        return const MapEntry<String, String>('', '');
      }
      final List<String> lineParts = line.split('\t');
      if (lineParts.length != 2) {
        throw UnsupportedError(
            'The following line encountered when reading dictionary file $dictionaryFile does not contain two words separated by a tab as expected:\n$line');
      }
      return MapEntry<String, String>(lineParts[0], lineParts[1]);
    }));
  }

  void update(Transliteration<S, T> transliteration) {
    if (transliteration.potentialTransliterations.length != 1) {
      throw ArgumentError(
          'Unable to update the dictionary file $dictionaryFile with new Transliteration $transliteration because it doesn\'t contain exactly one option.');
    }

    //regardless of if we actually update the file, update the in-memory dictionary in case we see this word again
    final String sourceWord = transliteration.sourceWordString;
    final String transliteratedWord = transliteration.firstTransliterationString;

    entries[sourceWord] = transliteratedWord;

    if (updatable) {
      _update(sourceWord, transliteratedWord);
    }
  }

  void _update(String sourceWord, String transliteration) =>
      dictionaryFile.writeAsStringSync('$sourceWord\t$transliteration\n', mode: FileMode.writeOnlyAppend);
}
