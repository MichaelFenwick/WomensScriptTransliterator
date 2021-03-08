library transliterator;

import 'dart:collection';

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
part 'transliterator/transliterator/paragraph_transliterator.dart';
part 'transliterator/transliterator/sentence_transliterator.dart';
part 'transliterator/transliterator/transliterator.dart';
part 'transliterator/transliterator/word_transliterator.dart';
