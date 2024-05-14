class UtilRecentWord {
  ///Get Language Global Language Name
  static String getRecentWordSetting(bool code) {
    switch (code) {
      case true:
        return 'Yes';
      case false:
        return 'No';
      default:
        return 'No';
    }
  }

  ///Singleton factory
  static final UtilRecentWord _instance = UtilRecentWord._internal();

  factory UtilRecentWord() {
    return _instance;
  }
  UtilRecentWord._internal();
}
