import 'package:flutter/material.dart'
    show Alignment, AnimatedContainer, BoxDecoration, Colors, Container, Widget;
import 'package:flutter_app_mario/hit_box/Body.dart';

class Platform {
  Body body;

  Platform({this.body});

  Widget displayPlatform() {
    return AnimatedContainer(
      alignment: Alignment(body.x, body.y),
      duration: Duration(milliseconds: 0),
      child: Container(
        width: body.width,
        height: body.height,
        decoration: BoxDecoration(
          color: Colors.brown,
        ),
      ),
    );
  }

  void moveLeft(double speed) {
    body.x += speed;
  }

  void moveRight(double speed) {
    body.x -= speed;
  }

  double get posX => body.x;

  double get posY => body.y;

  double get width => body.width;

  double get height => body.height;
}
