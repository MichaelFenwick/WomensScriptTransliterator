import 'dart:convert';
import 'dart:io';

import 'package:womens_script_transliterator/language.dart';
import 'package:womens_script_transliterator/transliterator.dart';
import 'package:womens_script_transliterator/word.dart';

List<String> inputFilePath = <String>['input_files'];
String inputFileName = 'stormlight_archive_unique_words_dehyphenated.txt';
List<String> outputFilePath = <String>['output_files'];
String outputFileName = 'transliterated_stormlight_archive.txt';

void main(List<String> arguments) {
  final Stream<String> inputFileStream = getInputFileStream();
  final IOSink outputFileStream = getOutputFileSink();

  inputFileStream.forEach((String wordString) {
    final Word<English> word = Word<English>.fromString(wordString.toString());
    final List<String> potentialTransliterations =
        Transliterator.transliterateWord<English, Alethi>(word).map<String>((Word<Alethi> translation) => translation.toString()).toList();
    final String outputLine = <String>[wordString, potentialTransliterations.length.toString(), '', ...potentialTransliterations].join('\t');
    // ignore: avoid_print
    print(outputLine);
    outputFileStream.writeln(outputLine);
  }).whenComplete(() => <Future<dynamic>>{outputFileStream.flush().whenComplete(() => outputFileStream.close)});
}

Stream<String> getInputFileStream() {
  final File inputFileStream = File(getFullFilePath(inputFilePath, inputFileName));

  return inputFileStream.openRead().transform(utf8.decoder).transform(const LineSplitter());
}

IOSink getOutputFileSink() {
  final File outputFile = File(getFullFilePath(outputFilePath, outputFileName))..writeAsStringSync(''); //Clear the file before continuing.

  return outputFile.openWrite(mode: FileMode.append);
}

String getFullFilePath(List<String> pathParts, String fileName) => pathParts.join(Platform.pathSeparator) + Platform.pathSeparator + fileName;
