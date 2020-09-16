import 'package:flutter/material.dart';

class Config {
  Config._();

  static final boxColors = <int, Color>{
    2: Colors.orange[50],
    4: Colors.orange[100],
    8: Colors.orange[200],
    16: Colors.orange[300],
    32: Colors.orange[400],
    64: Colors.orange[500],
    128: Colors.orange[600],
    256: Colors.orange[700],
    512: Colors.orange[800],
    1024: Colors.orange[900],
  };

  static String version = 'v1.0.0';
  static String about = 'Use your arrow keys to move the tiles. When two tiles with the same number touch, they merge into one!,';
  static String howToPlay =
      'Swipe up/down/left/right to move the tiles. When two tiles with the same number touch, they merge into one!';
}
