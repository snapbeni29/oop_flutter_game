import 'package:flutter/material.dart';
import 'package:flutter_app_mario/button/ButtonType.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_mario/button/ButtonTemplate.dart';
import 'package:flutter_app_mario/Player.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context, listen: false);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.blue,
              child: Consumer<Player>(
                builder: (_, player, __) => Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(player.posX, player.posY),
                      duration: Duration(milliseconds: 0),
                      child: player.displayPlayer(),
                    ),
                    player.displayProjectile(),
                  ],
                ),
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
                    start: player.moveLeft,
                    end: player.stopRunLeft,
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
                    start: player.moveRight,
                    end: player.stopRunRight,
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
