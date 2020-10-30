import 'dart:math';
import 'package:flutter/material.dart';

class Projectile {
  double projectileX;
  double projectileY;

  String direction;

  Projectile({this.projectileX, this.projectileY, this.direction});

  void moveRight() {
    direction = "right";
    projectileX += 0.03;
  }

  void moveLeft() {
    direction = "left";
    projectileX -= 0.03;
  }

  Widget displayProjectile() {
    if (direction == 'right') {
      return Container(
        width: 20.0,
        height: 20.0,
        child: Image.asset('images/Objects/Bullet_000.png'),
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: 20.0,
          height: 20.0,
          child: Image.asset('images/Objects/Bullet_000.png'),
        ),
      );
    }
  }

  double get posX => projectileX;

  double get posY => projectileY;

  String get getDirection => direction;
}
