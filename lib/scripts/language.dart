enum Languages {
  alethi,
  english;

  static String getName<L extends Language>() {
    switch (L) {
      case English:
        return 'English';
      case Alethi:
        return 'Alethi';
    }
    throw TypeError();
  }
}

abstract class Language {}

abstract class Alethi extends Language {}

abstract class English extends Language {}
