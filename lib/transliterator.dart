library transliterator;

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

import 'dictionary.dart';
import 'scripts/language.dart';
import 'transliteration_rule.dart';
import 'writer.dart';

part 'transliterator/direction.dart';
part 'transliterator/mode.dart';
part 'transliterator/result/empty_result.dart';
part 'transliterator/result/non_empty_result.dart';
part 'transliterator/result/result.dart';
part 'transliterator/result/result_pair.dart';
part 'transliterator/result/result_set.dart';
part 'transliterator/transliterated_pair.dart';
part 'transliterator/transliterator/compound_word_transliterator.dart';
part 'transliterator/transliterator/epub_chapter_transliterator.dart';
part 'transliterator/transliterator/epub_transliterator.dart';
part 'transliterator/transliterator/paragraph_transliterator.dart';
part 'transliterator/transliterator/sentence_transliterator.dart';
part 'transliterator/transliterator/string_transliterator.dart';
part 'transliterator/transliterator/structure_transliterator.dart';
part 'transliterator/transliterator/text_block_transliterator.dart';
part 'transliterator/transliterator/transliterator.dart';
part 'transliterator/transliterator/word_transliterator.dart';
part 'transliterator/transliterator/xml_transliterator.dart';
