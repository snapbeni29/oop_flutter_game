import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Projectile extends ChangeNotifier {
  double projectileX;
  double projectileY;

  String direction;

  Projectile({this.projectileX, this.projectileY, this.direction});

  void moveRight() {
    direction = "right";
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      projectileX += 0.015;
      notifyListeners();
    });
  }

  void moveLeft() {
    direction = "left";
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      projectileX -= 0.015;
      notifyListeners();
    });
  }

  Widget displayProjectile() {
    if (direction == 'right') {
      moveRight();
      if(projectileX < 1) {
        return Container(
          width: 30.0,
          height: 30.0,
          child: Image.asset('images/Objects/Bullet_000.png'),
        );
      }
    } else {
      if (projectileX > -1) {
        moveLeft();
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Container(
            width: 30.0,
            height: 30.0,
            child: Image.asset('images/Objects/Bullet_000.png'),
          ),
        );
      }
    }
  }

  double get posX {return projectileX;}
  double get posY => projectileY;
}
