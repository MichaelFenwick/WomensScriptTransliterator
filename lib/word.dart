import 'dart:collection';

import 'letters/letter.dart';

class Word<T extends Letter> extends ListBase<T> implements Comparable {
  List<T> letters;

  Word(this.letters);

  @override
  int get length => letters.length;

  @override
  set length(int length) => letters.length = length;

  @override
  T operator [](int index) => letters != null && letters.isNotEmpty ? letters[index] : null;

  @override
  void operator []=(int index, T value) => letters[index] = value;

  @override
  void add(T value) => letters.add(value);

  @override
  void addAll(Iterable<T> values) => letters.addAll(values);

  @override
  Word<T> sublist(int start, [int end]) {
    return Word<T>(letters.sublist(start, end));
  }

  @override
  String toString() => letters.join();

  @override
  bool operator ==(dynamic other) => other is Word<T> && toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  int compareTo(dynamic other) {
    if (other is! Word<T>) {
      throw TypeError();
    }
    return toString().compareTo(other.toString());
  }
}
