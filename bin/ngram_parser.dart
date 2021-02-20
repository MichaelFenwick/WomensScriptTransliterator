import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart' show NumberFormat;
// ignore: import_of_legacy_library_into_null_safe
import 'package:pedantic/pedantic.dart' show unawaited;

// A script used to parse the raw data from Google Ngrams into something I can easily import into a database.

Map<String, int> posMap = <String, int>{
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

RegExp rawNgramMatcher = RegExp(r'^(.*?)(_(NOUN|VERB|ADJ|ADV|PRON|DET|ADP|NUM|CONJ|PRT|X))?\t(.*?)$');

int count = 0;
int file = 0;

Future<void> processNgrams(List<String> args) async {
  for (int i = 1; i <= 71; i++) {
    await process(i);
  }
  exit(0);
}

Future<void> process(int fileNumber) async {
  int count = 0;
  final int file = fileNumber;
  final File rawNgramsFile = File('raw/rawngrams${fileNumber.toString().padLeft(2, '0')}');
  final File processedNgramsFile = File('raw/processedngrams$fileNumber');
  final Stream<String> rawNgrams = rawNgramsFile.openRead().transform(utf8.decoder).transform(const LineSplitter());
  final IOSink processedNgrams = processedNgramsFile.openWrite(mode: FileMode.append);
  await rawNgrams.forEach((String rawNgram) async {
    if (count % 5000 == 0) {
      // ignore: avoid_print
      print('File: $file\tLine: ${NumberFormat.compactLong().format(count)}');
    }
    count++;
    final Iterable<RegExpMatch> matches = rawNgramMatcher.allMatches(rawNgram);
    final String word = matches.first.group(1) ?? '';
    final int pos = posMap[matches.first.group(3)] ?? 0;
    final List<String> stats = matches.first.group(4)?.split('\t') ?? <String>[];

    if (stats.isNotEmpty) {
      for (final String stat in stats) {
        final List<String> splitStats = stat.split(',');
        processedNgrams.writeln(<String>[word, pos.toString(), ...splitStats].join('\t'));
      }
    }
  }).whenComplete(() async {
    await processedNgrams.flush();
    // ignore: avoid_print
    print('Finished File');
    unawaited(processedNgrams.flush().whenComplete(() => processedNgrams.close));
    return;
  });
  return;
}
