import 'package:flutter/material.dart';

class TTheme extends ChangeNotifier {
  static TTheme shared = TTheme();

  final ThemeData light = ThemeData.light();
  final ThemeData dark = ThemeData.dark();
  int mode = 0;

  void changeTheme() {
    mode += 1;
    if (mode > 2) {
      mode = 0;
    }
    // updateTheme();
    notifyListeners();
  }

  ThemeData getTheme() {
    switch (mode) {
      case 1:
        return light;
      case 2:
        return dark;
      default:
        return light;
    }
  }
}
