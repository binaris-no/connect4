import 'package:connect4/ui/game_v.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Connect4());
}

class Connect4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect 4',
      home: GameView(),
    );
  }
}
