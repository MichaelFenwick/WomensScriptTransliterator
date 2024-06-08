import 'dart:collection';

import 'alethi_glyph.dart';
import 'english_glyph.dart';
import 'glyph.dart';
import 'script.dart';

/// A [Word] is an iterable collection of [Glyph]s in a single [Script].
class Word<L extends Script> extends ListBase<Glyph<L>> implements Comparable<Word<L>> {
  final List<Glyph<L>> _glyphs;

  const Word(this._glyphs);

  //FIXME: This doesn't work for converting a WS string into a Word<Alethi> because it'll .toLowerCase() any `C` glyphs, which prevents them from becoming AlethiGlyph.ch glyphs. Alternatively, just allow lowercase `c` to be used as the identifier for AlethiGlyph.ch.
  /// Instantiates a new [Word] by converting each character in the provided [string] into the corresponding [Glyph] for the [Script] [L].
  Word.fromString(String string)
      : _glyphs = string.toLowerCase().split('').map((String character) {
          switch (L) {
            case English:
              return EnglishGlyph.fromString(character) as Glyph<L>;
            case Alethi:
              return AlethiGlyph.fromString(character) as Glyph<L>;
            default:
              throw TypeError();
          }
        }).toList();

  Type get script => L;

  /// Returns a new [Word] comprised of the [Glyph]s ranging from the [start] index through the [end] index (or the [Word]'s end if no [end] is specified.
  Word<L> subWord(int start, [int? end]) => Word<L>(_glyphs.sublist(start, end));

  //TODO: Add fun things like methods to see if a word is reflectable/rotatable and methods to get the reflection/rotation of this word.

  @override
  int get length => _glyphs.length;

  @override
  Glyph<L> operator [](int index) => _glyphs[index];

  @override
  void operator []=(int index, Glyph<L> value) => _glyphs[index] = value;

  @override
  set length(int newLength) => _glyphs.length = newLength;

  @override
  String toString() => _glyphs.join();

  @override
  bool operator ==(Object other) => other is Word<L> && toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  int compareTo(Word<L> other) => toString().compareTo(other.toString());
}
