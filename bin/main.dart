import 'dart:io';

import 'package:womens_script_transliterator/dictionary.dart';
import 'package:womens_script_transliterator/scripts/language.dart';
import 'package:womens_script_transliterator/transliterator.dart';
import 'package:womens_script_transliterator/writer.dart';

void main(List<String> arguments) async {
  final DateTime start = DateTime.now();
  await transliterateEpub();
  print('Completed in ${DateTime.now().difference(start).inMilliseconds} milliseconds.');
}

void transliterateDictionary() {
  final Dictionary<English, Alethi> saDictionary = FileDictionary<English, Alethi>(name: 'stormlight_archive.tsv', updatable: true);
  final WordTransliterator<English, Alethi> transliterator =
      WordTransliterator<English, Alethi>(mode: const Mode(algorithmBestOptionOnly: false), debugWriter: const NullWriter());
  int count = 0;
  int errorCount = 0;
  String output;
  for (final String inputWord in saDictionary.entries.keys) {
    final Result<Word, English, Alethi> result = transliterator.transliterate(Word(inputWord));
    if (result is ResultPair<Word, English, Alethi> && result.target.content != saDictionary.entries[inputWord]) {
      output = '$result but dictionary had ${saDictionary.entries[inputWord]!}';
      stderr.writeln(output);
      errorCount++;
      count++;
    } else if (result is ResultSet<Word, English, Alethi> && result.target.first.content != saDictionary.entries[inputWord]) {
      output = '$result but dictionary had ${saDictionary.entries[inputWord]!}';
      if (result.target.contains(saDictionary.entries[inputWord])) {
        print(output);
      } else {
        stderr.writeln(output);
        errorCount++;
      }
      count++;
    } else {
      // print(result);
    }
  }
  print(count);
  stderr.writeln(errorCount);
}

Future<void> transliterateEpub() async {
  const String inputFileDirectory = 'input_files/stormlight/epub/The Way of Kings (364)/';
  const String inputFileName = 'The Way of Kings - Brandon Sanderson.epub';

  final Dictionary<English, Alethi> saDictionary = FileDictionary<English, Alethi>(name: 'stormlight_archive.tsv', updatable: true);
  final ResultPair<File, English, Alethi> transliterationResult =
      await EpubTransliterator<English, Alethi>(dictionary: saDictionary).transliterate(File(inputFileDirectory + inputFileName));
  print('Wrote transliterated epub to ${transliterationResult.target.path}');
}
