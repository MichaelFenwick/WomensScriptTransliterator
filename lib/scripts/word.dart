import 'dart:collection';

import 'alethi_glyph.dart';
import 'english_glyph.dart';
import 'glyph.dart';
import 'script.dart';

/// A [Word] is an iterable collection of [Glyph]s in a single [Script].
class Word<G extends Glyph> extends ListBase<G> implements Comparable<Word<G>> {
  final List<G> _glyphs;

  const Word(this._glyphs);

  //FIXME: This doesn't work for converting a WS string into a Word<Alethi> because it'll .toLowerCase() any `C` glyphs, which prevents them from becoming AlethiGlyph.ch glyphs. Alternatively, just allow lowercase `c` to be used as the identifier for AlethiGlyph.ch.
  /// Instantiates a new [Word] by converting each character in the provided [string] into the corresponding [Glyph] subclass.
  Word.fromString(String string)
      : _glyphs = string.toLowerCase().split('').map((String character) {
          switch (G) {
            case EnglishGlyph:
              return EnglishGlyph.fromString(character) as G;
            case AlethiGlyph:
              return AlethiGlyph.fromString(character) as G;
            default:
              throw TypeError();
          }
        }).toList();

  Script get script {
    switch (G) {
      case EnglishGlyph:
        return Script.english;
      case AlethiGlyph:
        return Script.alethi;
      default:
        throw TypeError();
    }
  }

  /// Returns a new [Word] comprised of the [Glyph]s ranging from the [start] index through the [end] index (or the [Word]'s end if no [end] is specified.
  Word<G> subWord(int start, [int? end]) => Word<G>(_glyphs.sublist(start, end));

  //TODO: Add fun things like methods to see if a word is reflectable/rotatable and methods to get the reflection/rotation of this word.

  @override
  int get length => _glyphs.length;

  @override
  G operator [](int index) => _glyphs[index];

  @override
  void operator []=(int index, G value) => _glyphs[index] = value;

  @override
  set length(int newLength) => _glyphs.length = newLength;

  @override
  String toString() => _glyphs.join();

  @override
  bool operator ==(Object other) => other is Word<G> && toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  int compareTo(Word<G> other) => toString().compareTo(other.toString());
}
