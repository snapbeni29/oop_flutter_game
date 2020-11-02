import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/hit_box/Body.dart';

class Projectile {
  Body body;
  String direction;

  Projectile({this.body, this.direction});

  void moveRight() {
    direction = "right";
    body.x += 0.03;
  }

  void moveLeft() {
    direction = "left";
    body.x -= 0.03;
  }

  Widget displayProjectile() {
    if (direction == 'right') {
      return Container(
        width: body.width,
        height: body.height,
        child: Image.asset('images/Objects/Bullet_004.png'),
      );
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: body.width,
          height: body.height,
          child: Image.asset('images/Objects/Bullet_004.png'),
        ),
      );
    }
  }

  double get posX => body.x;

  double get posY => body.y;

  String get getDirection => direction;
}
