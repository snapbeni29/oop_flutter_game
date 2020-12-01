import 'package:corona_bot/controllers/LevelController.dart';
import 'package:corona_bot/controllers/PlayerController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:corona_bot/buttons/ButtonInstant.dart';
import 'package:corona_bot/buttons/ButtonJump.dart';
import 'package:corona_bot/buttons/ButtonRun.dart';

/*
  The game page is divided into two parts:
    Some space for the level + a pause button (top)
    Some space for the buttons (bottom)
 */
class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final levelProv = Provider.of<LevelController>(context, listen: false);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/Background/layer-1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Consumer<LevelController>(
                builder: (context, level, _) {
                  return ChangeNotifierProvider<PlayerController>.value(
                    value: level.player,
                    child: Consumer<PlayerController>(
                      builder: (context, _, __) {
                        return Stack(
                          children: [
                            level.displayLevel(),
                            // Pause button ------------------------------------
                            Container(
                              alignment: Alignment(-0.9, -0.8),
                              child: ButtonInstant(
                                icon: Icon(Icons.pause),
                                start: level.pause,
                              ),
                            ),
                            // Show time, score and coins ----------------------
                            Container(
                              alignment: Alignment(0.7, -0.9),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Time: " + level.time,
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            ),
                                          ),
                                          Text(
                                            "Score: " +
                                                level.score.toStringAsFixed(0),
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            ),
                                          ),
                                          Text(
                                            "Coins: " + level.coins.toString(),
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/Background/layer-2.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ButtonRun(
                    icon: Icon(Icons.arrow_back),
                    start: levelProv.moveLeft,
                    end: levelProv.stopMoveLeft,
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                  ButtonJump(
                    icon: Icon(Icons.arrow_upward),
                    start: levelProv.jump,
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                  ButtonInstant(
                    icon: Icon(Icons.whatshot),
                    start: levelProv.shoot,
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                  ButtonRun(
                    icon: Icon(Icons.arrow_forward),
                    start: levelProv.moveRight,
                    end: levelProv.stopMoveRight,
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
