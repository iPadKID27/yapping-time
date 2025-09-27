import 'package:flutter/material.dart';
import 'package:yappingtime/themes/light_mode.dart';
import 'package:yappingtime/themes/dark_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData.brightness == Brightness.dark;

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }

  void toggleTheme() {
  _themeData = isDarkMode ? lightMode : darkMode;
  notifyListeners();
}
}