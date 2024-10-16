import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String PREF_KEY = "pref_key";

  Future<void> setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(PREF_KEY, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PREF_KEY) ?? false;
  }
}