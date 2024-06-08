import 'dart:io';
import 'dart:typed_data';

import 'package:epubx/epubx.dart';
import 'package:path/path.dart' as path;
import 'package:womens_script_transliterator/scripts/script.dart';
import 'package:womens_script_transliterator/womens_script_transliterator.dart';
import 'package:womens_script_transliterator/writer.dart';

void main(List<String> arguments) async {
  final DateTime start = DateTime.now();
  await transliterateEpub();
  // ignore: avoid_print
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
      if (result.target.contains(Word(saDictionary.entries[inputWord] ?? ''))) {
        // ignore: avoid_print
        print(output);
      } else {
        stderr.writeln(output);
        errorCount++;
      }
      count++;
    } else {
      // ignore: avoid_print
      // print(result);
    }
  }
  // ignore: avoid_print
  print(count);
  stderr.writeln(errorCount);
}

void transliterateWordlist() {
  const String inputFileDirectory = 'input_files/wordlists/';
  const String outputFileDirectory = 'output_files/wordlists/';
  const String inputFileName = 'aspell60.txt';
  final List<String> wordlist = File(path.join(inputFileDirectory, inputFileName)).readAsLinesSync();
  final File outputFile = File(path.join(outputFileDirectory, '${inputFileName}_transliterated.tsv'));
  if (outputFile.existsSync()) {
    outputFile.deleteSync();
  }
  outputFile.createSync(recursive: true);

  final WordTransliterator<English, Alethi> transliterator =
      WordTransliterator<English, Alethi>(mode: const Mode(algorithmBestOptionOnly: false), debugWriter: const NullWriter());
  int count = 0;
  String transliterations;
  for (final String inputWord in wordlist) {
    final Result<Word, English, Alethi> result = transliterator.transliterate(Word(inputWord));
    if (result is ResultPair<Word, English, Alethi>) {
      transliterations = result.target.content;
    } else if (result is ResultSet<Word, English, Alethi>) {
      transliterations = result.target.join('\t');
    } else {
      transliterations = '';
    }
    count++;
    final String output = '$inputWord\t$transliterations';
    // ignore: avoid_print
    // print(output);
    outputFile.writeAsStringSync('$output\n', mode: FileMode.append);
  }
  // ignore: avoid_print
  print(count);
}

Future<void> transliterateEpub() async {
  const String inputFileDirectory = 'input_files/stormlight/epub/epubs/';
  const String inputFileName = 'ed.epub';

  final Dictionary<English, Alethi> saDictionary = FileDictionary<English, Alethi>(name: 'stormlight_archive.tsv', updatable: true);
  final File inputFile = File(path.join(inputFileDirectory, inputFileName));

  if (!inputFile.existsSync()) {
    throw ArgumentError.value('Expected file ${inputFile.path} to exist.');
  }

  final Uint8List epubData = inputFile.readAsBytesSync();

  // * Parse into epub object
  final EpubBook epubBook = await EpubReader.readBook(epubData);
  final ResultPair<EpubBook, English, Alethi> transliterationResult =
      EpubTransliterator<English, Alethi>(dictionary: saDictionary).transliterate(epubBook);
  final List<int>? transliteratedEpubData = EpubWriter.writeBook(transliterationResult.target);
  if (transliteratedEpubData != null) {
    final File outputFile = File(path.join(inputFileDirectory, '${inputFileName.substring(0, inputFileName.lastIndexOf('.'))}_transliterated.epub'))
      ..writeAsBytesSync(transliteratedEpubData);
    // ignore: avoid_print
    print('Wrote transliterated epub to ${outputFile.path}');
  }
}
