import 'package:womens_script_transliterator/letters/letter.dart';

import '../language.dart';
import 'alethi_digraph.dart';
import 'english_digraph.dart';

class Digraph<T extends Language> extends Letter<T> {
  final Letter<T> first;
  final Letter<T> second;

  const Digraph(this.first, this.second, String stringValue) : super(stringValue);

  static List<Digraph<T>> getInputDigraphs<T extends Language>() {
    switch (T) {
      case English:
        return EnglishDigraph.inputDigraphs as List<Digraph<T>>;
      case Alethi:
        return AlethiDigraph.inputDigraphs as List<Digraph<T>>;
      default:
        return [];
    }
  }

  static List<Digraph<T>> getOutputDigraphs<T extends Language>() {
    switch (T) {
      case English:
        return EnglishDigraph.outputDigraphs as List<Digraph<T>>;
      case Alethi:
        return AlethiDigraph.outputDigraphs as List<Digraph<T>>;
      default:
        return [];
    }
  }

  static Digraph<T> getDigraphFromString<T extends Language>(String string) {
    switch (T) {
      case English:
        return EnglishDigraph.stringMap[string] as Digraph<T>;
      case Alethi:
        return AlethiDigraph.stringMap[string] as Digraph<T>;
      default:
        return null;
    }
  }

  @override
  String toString() => first.toString() + second.toString();
}
