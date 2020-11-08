import 'package:flutter/material.dart';
import 'package:flutter_app_mario/hit_box/Body.dart';
import 'package:flutter_app_mario/level/Platform.dart';

class Enemy {
  Body body;
  int maxHealth;
  int _health;
  Platform platform;
  double speed = 0.01;

  Enemy({this.body, this.maxHealth, this.platform}) {
    _health = maxHealth;
  }

  Widget displayEnemy() {
    return Container(
      width: body.width,
      height: body.height,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.asset('images/Monsters/virus3.png'),
      ),
    );
  }

  Widget displayHealthBar() {
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
          width: body.width * (_health / maxHealth),
          height: body.width / 10.0,
          color: Colors.lightGreen,
        ),
      ),
    );
  }

  void moveOnce(double pW) {
    if (speed > 0) {
      if (getRightBoundary(body.x, body.width, pW) >
          getRightBoundary(platform.posX, platform.width, pW)) {
        speed = -speed;
      }
    } else {
      if (getLeftBoundary(body.x, body.width, pW) <
          getLeftBoundary(platform.posX, platform.width, pW)) {
        speed = -speed;
      }
    }

    body.x += speed;
  }

  void moveLeft(double speed) {
    body.x += speed;
  }

  void moveRight(double speed) {
    body.x -= speed;
  }

  void hurt() {
    _health--;
  }

  bool get dead => _health <= 0;
}
