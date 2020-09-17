import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TTheme extends ChangeNotifier {
  static TTheme shared = TTheme();

  final ThemeData light = ThemeData(
    brightness: Brightness.light,
    canvasColor: Colors.grey[300],
    primaryColor: Colors.white,
    buttonColor: Color(0xff157EFB),
    cardColor: Colors.blue[200],
    accentColor: Colors.grey,
    focusColor: Colors.grey[300],
    hintColor: Colors.black,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
  final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    buttonColor: Color(0xff1C88FB),
    cardColor: Colors.grey[800],
    accentColor: Colors.grey[900],
    focusColor: Colors.grey[800],
    hintColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );

  int mode = 1;

  static final boxColorsDark = <int, Color>{
    2: Colors.indigo[700],
    4: Colors.blue[700],
    8: Colors.cyan[700],
    16: Colors.teal[700],
    32: Colors.green[700],
    64: Colors.lightGreen[700],
    128: Colors.lime[700],
    256: Colors.yellow[700],
    512: Colors.amber[700],
    1024: Colors.orange[700],
    2048: Colors.deepOrange[700],
    4096: Colors.red[700],
  };
  static final boxColorsLight = <int, Color>{
    2: Colors.indigo[400],
    4: Colors.blue[400],
    8: Colors.cyan[400],
    16: Colors.teal[400],
    32: Colors.green[400],
    64: Colors.lightGreen[400],
    128: Colors.lime[400],
    256: Colors.yellow[400],
    512: Colors.amber[400],
    1024: Colors.orange[400],
    2048: Colors.deepOrange[400],
    4096: Colors.red[400],
  };

  void changeTheme() {
    mode += 1;
    if (mode > 2) {
      mode = 0;
    }
    notifyListeners();
  }

  ThemeData getTheme() {
    switch (mode) {
      case 0:
        if (isDark()) return dark;
        return light;
      case 1:
        return light;
      case 2:
        return dark;
      default:
        return light;
    }
  }

  Map<int, Color> getBoxColors() {
    switch (mode) {
      case 0:
        if (isDark()) return boxColorsDark;
        return boxColorsLight;
      case 1:
        return boxColorsLight;
      case 2:
        return boxColorsDark;
      default:
        return boxColorsLight;
    }
  }

  bool isDark() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    print(brightness);
    return brightness == Brightness.dark;
  }
}
