class TextFormatter {
  static String titleCase(String word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1);
  }

  ///Singleton factory
  static final TextFormatter _instance = TextFormatter._internal();

  factory TextFormatter() {
    return _instance;
  }
  TextFormatter._internal();
}
