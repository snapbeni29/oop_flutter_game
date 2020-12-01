import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/LevelController.dart';
import 'package:corona_bot/controllers/PlayerController.dart';
import 'package:corona_bot/pages/GamePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Intermediary class useful for declaring the provider
// and retrieving the number of the level to play
class PreGamePage extends StatelessWidget {
  final levelCreated = 1;

  @override
  Widget build(BuildContext context) {
    final int levelNumber = ModalRoute.of(context).settings.arguments;

    // If the level is not created yet, we display a screen
    if(levelNumber > levelCreated || levelNumber < 1){
      return Container(
        child: RaisedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("This level does not exist yet!"),
          color: BUTTON_COLOR,
        ),
      );
    }

    // otherwise,  start the game on the GamePage
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LevelController>(
          create: (_) => LevelController(
              new PlayerController(context), context, levelNumber),
        ),
      ],
      child: GamePage(),
    );
  }
}
