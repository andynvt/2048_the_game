import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Consum<T extends ChangeNotifier> extends StatelessWidget {
  final T value;
  final Widget Function(BuildContext, T) builder;

  const Consum({Key key, @required this.value, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: value,
      child: Consumer<T>(
        builder: (_, info, __) => builder(_, info),
      ),
    );
  }
}
