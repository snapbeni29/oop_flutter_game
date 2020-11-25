import 'dart:math';
import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';
import 'package:flutter/material.dart';

class ProjectileView {
  Widget displayProjectile(Direction direction, Body body, bool blue) {
    Image img;
    if(blue){
      img = Image.asset('images/Objects/BulletBlue_004.png');
    } else {
      img = Image.asset('images/Objects/Bullet_004.png');
    }
    if (direction == Direction.RIGHT || direction == Direction.STILL_RIGHT) {
      return Container(
          width: body.width,
          height: body.height,
          child: img
      );
    } else if (direction == Direction.LEFT ||
        direction == Direction.STILL_LEFT) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: body.width,
          height: body.height,
          child: img,
        ),
      );
    }
    // Should never come here
    return Container();
  }
}
