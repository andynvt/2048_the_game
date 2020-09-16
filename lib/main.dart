import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_game_2048/widget/theme.dart';
import 'game/game.dart';
import 'service/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TTheme.shared,
      child: Consumer<TTheme>(
        builder: (_, theme, __) {
          return MaterialApp(
            theme: theme.getTheme(),
            home: new Scaffold(
              body: SafeArea(
                child: GameWidget(size: 4),
              ),
            ),
          );
        },
      ),
    );
  }
}
