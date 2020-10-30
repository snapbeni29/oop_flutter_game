import 'package:flutter/material.dart';
import 'package:flutter_app_mario/GamePage.dart';
import 'package:flutter_app_mario/Level.dart';
import 'package:flutter_app_mario/Player/Player.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Player player = Player(context);
    Level level = Level(player, context);
    return ChangeNotifierProvider(
      create: (context) => player,
      child: ChangeNotifierProvider(
        create: (context) => level,
        child: GamePage(),
      ),
    );
  }
}
