import 'package:corona_bot/Body.dart';
import 'package:flutter/material.dart';

class EnemyView {
  Widget displayEnemy(Body body) {
    return Container(
      width: body.width,
      height: body.height,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.asset('images/Monsters/virus3.png'),
      ),
    );
  }

  Widget displayHealthBar(Body body, int health, int maxHealth) {
    return Container(
      width: body.width,
      height: body.width / 10.0,
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Container(
          width: body.width * (health / maxHealth),
          height: body.width / 10.0,
          color: Colors.lightGreen,
        ),
      ),
    );
  }
}
