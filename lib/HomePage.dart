import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Platform/Level.dart';
import 'package:flutter_app_mario/button/ButtonType.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_mario/button/ButtonTemplate.dart';
import 'package:flutter_app_mario/Player.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
        builder: (context, player, _) {
          return Consumer<Level>(
              builder: (context, level, _) {
                return Scaffold(
                  body: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.blue,
                          child: Stack(
                            children: [
                              level.displayLevel(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
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
                                start: player.jump,
                              ),
                              ButtonTemplate(
                                type: ButtonType.shoot,
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
              }
          );
        }
    );
  }
}
