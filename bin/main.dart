import 'dart:convert';
import 'dart:io';

import 'package:womens_script_transliterator/dictionary.dart';
import 'package:womens_script_transliterator/scripts/language.dart';
import 'package:womens_script_transliterator/transliterator.dart';

import 'word_list_transliterator.dart';

void main(List<String> arguments) {
  // String action = arguments[0];
  // List<String> actionArgs = arguments.sublist(1);

  final Dictionary<English, Alethi> saDictionary = FileDictionary<English, Alethi>(name: 'stormlight_archive.tsv', updatable: true);
  // final WordListTransliterator<English, Alethi> transliterator =
  //     WordListTransliterator<English, Alethi>(WordTransliterator<English, Alethi>(dictionary: saDictionary));

  // final WordListReader reader = WordListReader(mode: WordListReaderMode.multipleWordsPerLine);
  final WordListReader reader = WordListReader(inputFilePath: 'input_files/The Way of Kings - Brandon Sanderson.txt', mode: WordListReaderMode.oneWordPerLine);
  final ParagraphTransliterator<English, Alethi> transliterator =
      ParagraphTransliterator<English, Alethi>(mode: const Mode(algorithmBestOptionOnly: false), dictionary: saDictionary);

  IOSink outputFileSink = getOutputFileSink();
  outputFileSink
    ..writeAll(transliterator.transliterateAll(reader.getWordList(), useOutputWriter: false).map((Result<String, English, Alethi> e) {
      if (e is EmptyResult) {
        return '';
      }
      if (e is ResultPair) {
        return '${(e as ResultPair<String, English, Alethi>).target}\n';
      }
      return '${(e as ResultSet<String, English, Alethi>).target.first}\n';
    }))
    ..flush().whenComplete(() => outputFileSink.close());
}

IOSink getOutputFileSink() {
  var outputFileSink = File('C:/code/WordTools/output_files/TWoK.txt');
  outputFileSink.writeAsStringSync(''); //Clear the file before continuing.

  return outputFileSink.openWrite(mode: FileMode.append, encoding: utf8);
}
