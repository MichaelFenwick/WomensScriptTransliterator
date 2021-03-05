import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:womens_script_transliterator/scripts/language.dart';
import 'package:womens_script_transliterator/transliterator.dart';

class WordListTransliterator<S extends Language, T extends Language> {
  final Transliterator<String, S, T> transliterator;

  WordListTransliterator(this.transliterator);

  Iterable<Result<String, S, T>> transliterateWordList(Iterable<String> words) => words.map(_transliterateWord);
  Stream<Result<String, S, T>> transliterateWordStream(Stream<String> words) => words.map(_transliterateWord);

  Result<String, S, T> _transliterateWord(String word) => transliterator.transliterate(word);
}

enum WordListReaderMode { oneWordPerLine, multipleWordsPerLine }

class WordListReader {
  final String inputFilePath;
  final WordListReaderMode mode;
  static const String defaultInputFilePath = 'input_files/input.txt';
  File _inputFile = File('');

  WordListReader({this.inputFilePath = defaultInputFilePath, this.mode = WordListReaderMode.oneWordPerLine}) {
    _inputFile = File(inputFilePath);
  }

  Stream<String> getWordStream() {
    final Stream<String> lineStream = _inputFile.openRead().transform(utf8.decoder).transform(const LineSplitter());
    switch (mode) {
      case WordListReaderMode.oneWordPerLine:
        return lineStream;
      case WordListReaderMode.multipleWordsPerLine:
        return lineStream.expand(splitStringByWhiteSpace);
    }
  }

  List<String> getWordList() {
    switch (mode) {
      case WordListReaderMode.oneWordPerLine:
        return _inputFile.readAsLinesSync();
      case WordListReaderMode.multipleWordsPerLine:
        return _inputFile.readAsLinesSync().expand(splitStringByWhiteSpace).toList();
    }
  }

  /// Splits the input string into an iterable by separating the characters by the presence of whitespace or other extra-word character.
  ///
  /// Because this assumes that the input string has had its trailing line break removed (as happens by default when using LineSplitter) a new linebreak is appended to the end of the string before processing.
  /// The whitespace separating elements is appended to the preceding elements, which ensures that `'$string\n' == join(splitStringByWhiteSpace(string))`.
  Iterable<String> splitStringByWhiteSpace(String string) => '$string\n'.split(RegExp(r'(?<=[\s-])'));
}
