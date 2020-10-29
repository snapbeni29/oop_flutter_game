import 'package:flutter/material.dart';

class Platform {
  double width;
  double height;

  double posX;
  double posY;

  Platform({this.width, this.height, this.posX, this.posY});

  Widget displayPlatform() {
    return AnimatedAlign(
      alignment: Alignment(posX, posY),
      duration: Duration(milliseconds: 0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.brown,
        ),
      ),
    );
  }

  void moveLeft(double speed){
    posX += speed;
  }

  void moveRight(double speed){
    posX -= speed;
  }

}
