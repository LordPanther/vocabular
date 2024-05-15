import 'package:vocab_app/data/local/pref.dart';

class RecentWordSetting {
  /// Default Language
  static bool? defaultWordSetting = LocalPref.getBool("showRecentWord") ?? false;

  ///Singleton factory
  static final RecentWordSetting _instance = RecentWordSetting._internal();

  factory RecentWordSetting() {
    return _instance;
  }

  RecentWordSetting._internal();
}
