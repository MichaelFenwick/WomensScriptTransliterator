import 'dart:io';
import 'dart:typed_data';

import 'package:epubx/epubx.dart';
import 'package:path/path.dart' as path;
import 'package:womens_script_transliterator/scripts/script.dart';
import 'package:womens_script_transliterator/womens_script_transliterator.dart';
import 'package:womens_script_transliterator/writer.dart';

void main(List<String> arguments) async {
  final DateTime start = DateTime.now();
  // transliterateDictionary();
  // transliterateWordlist();
  await transliterateEpub();
  // ignore: avoid_print
  print('Completed in ${DateTime.now().difference(start).inMilliseconds} milliseconds.');
}

/// Transliterates all the words in a dictionary using the best guess algorithm, and compares the results to the transliteration that was actually in the dictionary. Outputs cases where the algorithm and dictionary don't agree with one another, giving what the expected and actual transliterations were, as well as the list of potential transliteration the algorithm gives for the word.
///
/// This function is useful for looking to see if there are any transliteration rules which can be added or tweaked to improve the transliteration in the case that an unknown word is encountered in normal operation.
void transliterateDictionary() {
  final Dictionary<English, Alethi> saDictionary = FileDictionary<English, Alethi>.fromName(name: 'stormlight_archive.tsv', isUpdatable: true);
  final WordTransliterator<English, Alethi> transliterator =
      WordTransliterator<English, Alethi>(mode: const Mode(algorithmBestOptionOnly: false), debugWriter: const NullWriter());
  int count = 0;
  int errorCount = 0;
  String output;
  for (final String inputWord in saDictionary.keys) {
    final Result<Word, English, Alethi> result = transliterator.transliterate(Word(inputWord));
    if (result is ResultPair<Word, English, Alethi> && result.target.content != saDictionary[inputWord]) {
      output = '$result but dictionary had ${saDictionary[inputWord]!}';
      stderr.writeln(output);
      errorCount++;
      count++;
    } else if (result is ResultSet<Word, English, Alethi> && result.target.first.content != saDictionary[inputWord]) {
      output = '$result but dictionary had ${saDictionary[inputWord]!}';
      if (result.target.contains(Word(saDictionary[inputWord] ?? ''))) {
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

/// Transliterates all the words in an input file and outputs the full list of possible transliterations given by the algorithm into an output file as a tab separated list.
///
/// This function is useful for transliterating a set of words to have their proper transliterations either confirmed or selected from one of the options listed for the purposes making a set of words to create or add to a dictionary file.
void transliterateWordlist() {
  const String inputFileDirectory = 'input_files/wordlists/';
  const String outputFileDirectory = 'output_files/wordlists/';
  const String inputFileName = 'aspell60leftovers.txt';
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

/// Transliterates the text of a given epub file and writes the output into a new epub file with the transliterated text. The new file will also have some minor changes to make the transliterated text easier to read.
Future<void> transliterateEpub() async {
  const String inputFileDirectory = 'input_files/stormlight/epub/epubs/';
  const String inputFileName = 'row.epub';

  final Dictionary<English, Alethi> saDictionary = FileDictionary<English, Alethi>.fromName(name: 'stormlight_archive.tsv', isUpdatable: true);
  final File inputFile = File(path.join(inputFileDirectory, inputFileName));

  if (!inputFile.existsSync()) {
    throw ArgumentError.value('Expected file ${inputFile.path} to exist.');
  }

  final Uint8List epubData = inputFile.readAsBytesSync();

  // * Parse into epub object
  final EpubBook epubBook = await EpubReader.readBook(epubData);
  final ResultPair<EpubBook, English, Alethi> transliterationResult = EpubTransliterator<English, Alethi>(dictionary: saDictionary).transliterate(epubBook);
  final List<int>? transliteratedEpubData = EpubWriter.writeBook(transliterationResult.target);
  if (transliteratedEpubData != null) {
    final File outputFile = File(path.join(inputFileDirectory, '${inputFileName.substring(0, inputFileName.lastIndexOf('.'))}_transliterated.epub'))
      ..writeAsBytesSync(transliteratedEpubData);
    // ignore: avoid_print
    print('Wrote transliterated epub to ${outputFile.path}');
  }
}
