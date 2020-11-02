import 'package:flutter/material.dart';
import 'package:flutter_app_mario/level/Level.dart';
import 'package:flutter_app_mario/player/Player.dart';
import 'package:flutter_app_mario/views/GamePage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Player player = new Player(context);
    Level level = new Level(player, context);
    return ChangeNotifierProvider(
      create: (context) => player,
      child: ChangeNotifierProvider(
        create: (context) => level,
        child: GamePage(),
      ),
    );
  }
}
