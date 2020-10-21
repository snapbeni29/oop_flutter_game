import 'package:flutter/material.dart';
import 'package:flutter_app_mario/button.dart';
import 'package:flutter_app_mario/player.dart';
import 'package:flutter_app_mario/projectile.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  Projectile proj = Projectile(projectileY: 0.9, projectileX: 0, direction: "right");
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context, listen : false);
    final projec = Provider.of<Projectile>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.blue,
              child: Stack(
                children: [
                  Consumer<Player>(
                    builder: (_, player, __) => AnimatedContainer(
                      alignment: Alignment(player.posX,player.posY),
                      duration: Duration(milliseconds: 0),
                      child: player.displayPlayer(),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 0),
                    alignment: Alignment(projec.posX, projec.posY),
                    child: projec.displayProjectile(),
                  ),
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
                  MyButton(
                    child: Icon(Icons.arrow_back),
                    function: player.moveLeft,
                  ),
                  MyButton(
                    child: Icon(Icons.arrow_upward),
                    function: player.jump,
                  ),
                  MyButton(
                    child: Icon(Icons.whatshot),
                    function: player.shoot,
                  ),
                  MyButton(
                    child: Icon(Icons.arrow_forward),
                    function: player.moveRight,
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
