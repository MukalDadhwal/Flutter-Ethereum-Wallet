import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter/material.dart';

enum CurrentThemeMode {
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  CurrentThemeMode _currTheme = CurrentThemeMode.dark;

  CurrentThemeMode get currentTheme {
    return _currTheme;
  }

  void toggleTheme(BuildContext context) {
    if (_currTheme == ThemeMode.dark) {
      _currTheme = CurrentThemeMode.light;
    } else {
      _currTheme = CurrentThemeMode.dark;
    }
    notifyListeners();
  }
}
