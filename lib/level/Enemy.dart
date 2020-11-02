import 'package:flutter/material.dart';
import 'package:flutter_app_mario/hit_box/Body.dart';
import 'package:flutter_app_mario/player/Player.dart';

class Enemy {
  Body body;
  int maxHealth;
  int _health;
  int name;

  Enemy({this.body, this.maxHealth, this.name}) {
    _health = maxHealth;
  }

  Widget displayEnemy() {
    return Container(
      width: body.width,
      height: body.height,
      child: Image.asset('images/Objects/Bullet_003.png'),
    );
  }

  Widget displayHealthBar(){
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

  void moveOnce(Player player) {
    double xDirection = body.x - player.posX;
    double yDirection = body.y - player.posY + 0.1;

    if (xDirection < 0) {
      body.x += 0.01;
    } else {
      body.x -= 0.01;
    }

    if (yDirection < 0) {
      body.y += 0.01;
    } else {
      body.y -= 0.01;
    }
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
