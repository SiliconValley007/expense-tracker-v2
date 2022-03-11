import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference {
  light,
  dark,
  system,
}

class ThemeService {
  static const String _themeKey = 'theme_key';
  Future<bool> setTheme(ThemePreference themePreference) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(_themeKey, themePreference.index);
  }

  Future<int> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(_themeKey) ?? ThemePreference.values.length - 1;
  }
}