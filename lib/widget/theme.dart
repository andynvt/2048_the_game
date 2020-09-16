import 'package:flutter/material.dart';

class TTheme extends ChangeNotifier {
  static TTheme shared = TTheme();

  final ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'SFPro',
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    )
  );
  final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'SFPro',
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    )
  );
  int mode = 1;

  void changeTheme() {
    mode += 1;
    if (mode > 2) {
      mode = 0;
    }
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
