abstract class Language {
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

enum Languages { alethi, english }

abstract class Alethi extends Language {}

abstract class English extends Language {}
