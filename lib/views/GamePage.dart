import 'package:flutter/material.dart';
import 'package:flutter_app_mario/level/Level.dart';
import 'package:flutter_app_mario/button/ButtonType.dart';
import 'package:flutter_app_mario/button/ButtonTemplate.dart';
import 'package:flutter_app_mario/player/Player.dart';
import 'package:provider/provider.dart';

/*
  The game page is divided into two parts:
    Some space for the level + a pause button (top)
    Some space for the buttons (bottom)
 */

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Level>(builder: (context, level, _) {
      return ChangeNotifierProvider<Player>.value(
        value: level.player,
        child: Consumer<Player>(builder: (context, player, _) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Container(
                    color: Colors.blue,
                    child: Stack(
                      children: [
                        level.displayLevel(),
                        Container(
                          alignment: Alignment(-0.9, -0.9),
                          child: ButtonTemplate(
                            type: ButtonType.instant,
                            icon: Icon(Icons.pause),
                            start: () {
                              level.end();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    color: Colors.brown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ButtonTemplate(
                          type: ButtonType.run,
                          icon: Icon(Icons.arrow_back),
                          start: level.moveLeft,
                          end: level.stopMoveLeft,
                        ),
                        ButtonTemplate(
                          type: ButtonType.jump,
                          icon: Icon(Icons.arrow_upward),
                          start: level.jump,
                        ),
                        ButtonTemplate(
                          type: ButtonType.instant,
                          icon: Icon(Icons.whatshot),
                          start: player.shoot,
                        ),
                        ButtonTemplate(
                          type: ButtonType.run,
                          icon: Icon(Icons.arrow_forward),
                          start: level.moveRight,
                          end: level.stopMoveRight,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
