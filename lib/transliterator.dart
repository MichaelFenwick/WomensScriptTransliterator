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
import 'scripts/unicode.dart';
import 'transliteration_rule.dart';
import 'writer.dart';

part 'transliterator/direction.dart';
part 'transliterator/mode.dart';
part 'transliterator/result/empty_result.dart';
part 'transliterator/result/non_empty_result.dart';
part 'transliterator/result/result.dart';
part 'transliterator/result/result_pair.dart';
part 'transliterator/result/result_set.dart';
part 'transliterator/string_unit/paragraph.dart';
part 'transliterator/string_unit/sentence.dart';
part 'transliterator/string_unit/string_unit.dart';
part 'transliterator/string_unit/sub_unit.dart';
part 'transliterator/string_unit/super_unit.dart';
part 'transliterator/string_unit/text_block.dart';
part 'transliterator/string_unit/word.dart';
part 'transliterator/transliterated_pair.dart';
part 'transliterator/transliterator/atom.dart';
part 'transliterator/transliterator/string/paragraph_transliterator.dart';
part 'transliterator/transliterator/string/sentence_transliterator.dart';
part 'transliterator/transliterator/string/string_transliterator.dart';
part 'transliterator/transliterator/string/text_block_transliterator.dart';
part 'transliterator/transliterator/string/word_transliterator.dart';
part 'transliterator/transliterator/structure/epub_chapter_transliterator.dart';
part 'transliterator/transliterator/structure/epub_transliterator.dart';
part 'transliterator/transliterator/structure/structure_transliterator.dart';
part 'transliterator/transliterator/structure/xml_transliterator.dart';
part 'transliterator/transliterator/transliterator.dart';
