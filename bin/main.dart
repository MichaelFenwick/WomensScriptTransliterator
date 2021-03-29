import 'dart:io';

import 'package:womens_script_transliterator/dictionary.dart';
import 'package:womens_script_transliterator/scripts/language.dart';
import 'package:womens_script_transliterator/transliterator.dart';

void main(List<String> arguments) {
  const String inputFileDirectory = 'input_files/stormlight/epub/The Way of Kings (364)/';
  const String inputFileName = 'The Way of Kings - Brandon Sanderson.epub';

  final Dictionary<English, Alethi> saDictionary = FileDictionary<English, Alethi>(name: 'stormlight_archive.tsv', updatable: true);
  EpubTransliterator<English, Alethi>(dictionary: saDictionary).transliterate(File(inputFileDirectory + inputFileName));
}
