import 'package:flutter/material.dart';
import 'package:flutter_app_mario/level/Level.dart';
import 'package:flutter_app_mario/player/Player.dart';
import 'package:flutter_app_mario/views/GamePage.dart';
import 'package:provider/provider.dart';

// Class useful for declaring the provider
class PreGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int levelNumber = ModalRoute.of(context).settings.arguments;
    print(levelNumber);

    /*
       TODO: Level will be created with the levelNumber as argument.
        We only have one level so far.
     */

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Level>(
          create: (_) => Level(new Player(context), context),
        ),
      ],
      child: GamePage(),
    );
  }
}