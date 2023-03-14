import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _prefs;

  SharedPreferencesService._() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _prefs = prefs;
      },
    );
  }

  factory SharedPreferencesService() {
    _instance ??= SharedPreferencesService._();
    return _instance!;
  }
}
