import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockThemeNotifier with ChangeNotifier {
  StockThemeNotifier() {
    initialize();
  }
  ThemeMode _themeMode = ThemeMode.system;
  bool isDarkTheme = false;
  static const String _preferencesKey = 'selected_theme';
  String _selectedTheme = 'System Default';
  bool _hasChanges = false;

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }

  String get selectedTheme => _selectedTheme;
  bool get hasChanges => _hasChanges;

  Future<void> initialize() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedTheme = preferences.getString(_preferencesKey) ?? 'system';

      switch (savedTheme) {
        case 'system':
          setSystemTheme(save: false);
          break;
        case 'light':
          setLightTheme(save: false);
          break;
        case 'dark':
          setDarkTheme(save: false);
          break;
      }
    } catch (e) {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void updateTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void updateHasChanges(bool value) {
    _hasChanges = value;
    notifyListeners();
  }

  void setSystemTheme({bool save = true}) {
    _themeMode = ThemeMode.system;
    isDarkTheme =
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    _selectedTheme = 'System Default';
    notifyListeners();
    if (save) {
      _persistTheme('system');
    }
  }

  void setLightTheme({bool save = true}) {
    _themeMode = ThemeMode.light;
    isDarkTheme = false;
    _selectedTheme = 'Light';
    notifyListeners();
    if (save) {
      _persistTheme('light');
    }
  }

  void setDarkTheme({bool save = true}) {
    _themeMode = ThemeMode.dark;
    isDarkTheme = true;
    _selectedTheme = 'Dark';
    notifyListeners();
    if (save) {
      _persistTheme('dark');
    }
  }

  Future<void> _persistTheme(String theme) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferencesKey, theme);
  }
}
