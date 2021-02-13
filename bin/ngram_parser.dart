import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pedantic/pedantic.dart';

// A script used to parse the raw data from Google Ngrams into something I can easily import into a database.

var posMap = {
  'NOUN': 1,
  'VERB': 2,
  'ADJ': 3,
  'ADV': 4,
  'PRON': 5,
  'DET': 6,
  'ADP': 7,
  'NUM': 8,
  'CONJ': 9,
  'PRT': 10,
  'X': 11,
};

var rawNgramMatcher = RegExp(r'^(.*?)(_(NOUN|VERB|ADJ|ADV|PRON|DET|ADP|NUM|CONJ|PRT|X))?\t(.*?)$');

var count = 0;
var file = 0;

void processNgrams(List<String> args) async {
  for (var i = 1; i <= 71; i++) {
    await process(i);
  }
  exit(0);
}

Future<void> process(fileNumber) async {
  var count = 0;
  var file = fileNumber;
  var rawNgramsFile = await File('raw/rawngrams' + fileNumber.toString().padLeft(2, '0'));
  var processedNgramsFile = await File('raw/processedngrams' + fileNumber.toString());
  var rawNgrams = await rawNgramsFile.openRead().transform(utf8.decoder).transform(LineSplitter());
  var processedNgrams = await processedNgramsFile.openWrite(mode: FileMode.append, encoding: utf8);
  await rawNgrams.forEach((rawNgram) async {
    if (count % 5000 == 0) {
      print('File: ' + file.toString() + '\tLine: ' + NumberFormat.compactLong().format(count));
    }
    count++;
    var matches = await rawNgramMatcher.allMatches(rawNgram);
    var word = await matches.first.group(1);
    var pos = await posMap[matches.first.group(3)] ?? 0;
    var stats = await matches.first.group(4).split('\t');

    for (var stat in stats) {
      var splitStats = stat.split(',');
      await processedNgrams.writeln([word, pos, ...splitStats].join('\t'));
    }
  }).whenComplete(() async {
    await processedNgrams.flush();
    print('Finished File');
    unawaited(processedNgrams.flush().whenComplete(() => () {
          processedNgrams.close();
        }));
    return;
  });
  return;
}
