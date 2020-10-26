import 'package:flutter/material.dart' show Alignment, AnimatedContainer, BoxDecoration, Colors, Container, Widget;

class Platform {
  double width;
  double height;

  double posX;
  double posY;

  Platform({this.width, this.height, this.posX, this.posY});

  Widget displayPlatform() {
    return AnimatedContainer(
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

  void moveLeft(){
    posX += 0.015;
  }

  void moveRight(){
    posX -= 0.015;
  }

}
