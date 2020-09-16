import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_game_2048/theme.dart';
import 'game.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = '2048';
    return ChangeNotifierProvider.value(
      value: TTheme.shared,
      child: Consumer<TTheme>(
        builder: (_, theme, __) {
          return MaterialApp(
            title: appTitle,
            theme: theme.getTheme(),
            home: new Scaffold(
              body: GameWidget(
                row: 4,
                column: 4,
              ),
            ),
          );
        },
      ),
    );
  }
}
