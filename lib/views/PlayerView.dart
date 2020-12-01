import 'dart:math';
import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/obstacles/ProjectileController.dart';
import 'package:flutter/material.dart';

class PlayerView {
  Widget displayPlayer(int playerSprite, Direction vertical,
      Direction horizontal, double width, double height, bool red, bool blue) {
    // We first have to define the sprite to use depending on its direction
    // (jumping, falling, running left/right) and its state (blue or red potion)
    Image img;
    if (vertical == Direction.UP) {
      if (red) {
        img = Image.asset('images/Player/JumpRed (5).png');
      } else if (blue) {
        img = Image.asset('images/Player/JumpBlue (5).png');
      } else {
        img = Image.asset('images/Player/Jump (5).png');
      }
    } else if (vertical == Direction.DOWN) {
      if (red) {
        img = Image.asset('images/Player/JumpRed (9).png');
      } else if (blue) {
        img = Image.asset('images/Player/JumpBlue (9).png');
      } else {
        img = Image.asset('images/Player/Jump (9).png');
      }
    } else if (horizontal == Direction.RIGHT || horizontal == Direction.LEFT) {
      if (red) {
        img = Image.asset(
            'images/Player/RunRed (' + (playerSprite + 1).toString() + ').png');
      } else if (blue) {
        img = Image.asset('images/Player/RunBlue (' +
            (playerSprite + 1).toString() +
            ').png');
      } else {
        img = Image.asset(
            'images/Player/Run (' + (playerSprite + 1).toString() + ').png');
      }
    } else {
      if (red) {
        img = Image.asset('images/Player/IdleRed (1).png');
      } else if (blue) {
        img = Image.asset('images/Player/IdleBlue (1).png');
      } else {
        img = Image.asset('images/Player/Idle (1).png');
      }
    }

    // The sprites are looking right initially
    if (horizontal == Direction.RIGHT || horizontal == Direction.STILL_RIGHT) {
      return Container(
        width: width,
        height: height,
        child: FittedBox(
          fit: BoxFit.fill,
          child: img,
        ),
      );
    }
    // When going left, we have to rotate the sprite by pi
    else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: width,
          height: height,
          child: FittedBox(
            fit: BoxFit.fill,
            child: img,
          ),
        ),
      );
    }
  }

  /// Shows the health bar of the player
  Widget displayLife(double lifeWidth, double life) {
    return Container(
      width: lifeWidth,
      height: lifeWidth / 10.0,
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
        ),
        child: Container(
          width: lifeWidth * life,
          height: lifeWidth / 10.0,
          color: Colors.lightGreen,
        ),
      ),
    );
  }

  /// Creates a list of widgets with the projectile.display() function
  Widget displayProjectiles(
      List<ProjectileController> projectileList) {
    List<Widget> widgetProjectileList = new List();

    for (ProjectileController projectile in projectileList) {
      widgetProjectileList.add(AnimatedContainer(
        alignment: Alignment(projectile.body.x, projectile.body.y),
        duration: Duration(milliseconds: 0),
        child: projectile.displayProjectile(),
      ));
    }

    return Stack(
      children: widgetProjectileList,
    );
  }
}
