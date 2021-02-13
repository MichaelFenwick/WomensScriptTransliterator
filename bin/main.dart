import 'dart:convert';
import 'dart:io';

import 'package:womens_script_transliterator/language.dart';
import 'package:womens_script_transliterator/letters/letter.dart';
import 'package:womens_script_transliterator/transliterator.dart';
import 'package:womens_script_transliterator/word.dart';

var inputFilePath = ['input_files'];
var inputFileName = 'top 1 million.txt';
var outputFilePath = ['output_files'];
var outputFileName = 'transliterated top 1 million.txt';

void main(List<String> arguments) {
  var inputFileStream = getInputFileStream();
  var outputFileStream = getOutputFileStream();

  inputFileStream.forEach((wordString) {
    var word = Word(Letter.string2Letters<English>(wordString.toString()));
    var potentialTransliterations = Transliterator.transliterateWord<English, Alethi>(word).map((translation) => translation.join('')).toList();
    var outputLine = [wordString, potentialTransliterations.length, '', ...potentialTransliterations].join('\t');
    print(outputLine);
    outputFileStream.writeln(outputLine);
  }).whenComplete(() => {
        outputFileStream.flush().whenComplete(() => () {
              outputFileStream.close();
            })
      });
}

Stream<String> getInputFileStream() {
  var wordlistFile = File(inputFilePath.join(Platform.pathSeparator) + inputFileName);

  return wordlistFile.openRead().transform(utf8.decoder).transform(LineSplitter());
}

IOSink getOutputFileStream() {
  var processedNgramsFile = File(outputFilePath.join(Platform.pathSeparator) + outputFileName);

  return processedNgramsFile.openWrite(mode: FileMode.append, encoding: utf8);
}
