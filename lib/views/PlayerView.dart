import 'dart:math';
import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/obstacles/ProjectileController.dart';
import 'package:flutter/material.dart';

/// View class of the player
class PlayerView {
  /// Displays the player.
  ///
  /// Depending on the state of the player and if he had bought a skin or not
  /// the appearance of the player changes.
  Widget displayPlayer(
      int playerSprite,
      Direction vertical,
      Direction horizontal,
      double width,
      double height,
      bool red,
      bool blue,
      bool collision,
      String hat) {
    // We first have to define the sprite to use depending on its direction
    // (jumping, falling, running left/right) and its state (blue or red potion)
    Image img;
    if (vertical == Direction.UP) {
      if (red) {
        img = Image.asset('images/Player/Jump' + hat + 'Red (5).png');
      } else if (blue) {
        img = Image.asset('images/Player/Jump' + hat + 'Blue (5).png');
      } else {
        img = Image.asset('images/Player/Jump' + hat + ' (5).png');
      }
    } else if (vertical == Direction.DOWN) {
      if (red) {
        img = Image.asset('images/Player/Jump' + hat + 'Red (9).png');
      } else if (blue) {
        img = Image.asset('images/Player/Jump' + hat + 'Blue (9).png');
      } else {
        img = Image.asset('images/Player/Jump' + hat + ' (9).png');
      }
    } else if ((horizontal == Direction.RIGHT ||
            horizontal == Direction.LEFT) &&
        collision) {
      if (red) {
        img = Image.asset('images/Player/Idle' + hat + 'Red (1).png');
      } else if (blue) {
        img = Image.asset('images/Player/Idle' + hat + 'Blue (1).png');
      } else {
        img = Image.asset('images/Player/Idle' + hat + ' (1).png');
      }
    } else if (horizontal == Direction.RIGHT || horizontal == Direction.LEFT) {
      if (red) {
        img = Image.asset('images/Player/Run' +
            hat +
            'Red (' +
            (playerSprite + 1).toString() +
            ').png');
      } else if (blue) {
        img = Image.asset('images/Player/Run' +
            hat +
            'Blue (' +
            (playerSprite + 1).toString() +
            ').png');
      } else {
        img = Image.asset('images/Player/Run' +
            hat +
            ' (' +
            (playerSprite + 1).toString() +
            ').png');
      }
    } else {
      if (red) {
        img = Image.asset('images/Player/Idle' + hat + 'Red (1).png');
      } else if (blue) {
        img = Image.asset('images/Player/Idle' + hat + 'Blue (1).png');
      } else {
        img = Image.asset('images/Player/Idle' + hat + ' (1).png');
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
          color: HURT_COLOR,
          border: Border.all(
            color: BORDER_COLOR,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: LIFE_COLOR,
          ),
          width: lifeWidth * life,
          height: lifeWidth / 10.0,
        ),
      ),
    );
  }

  /// Creates a list of widgets with the projectile.display() function
  Widget displayProjectiles(List<ProjectileController> projectileList) {
    List<Widget> widgetProjectileList = new List();

    for (ProjectileController projectile in projectileList) {
      widgetProjectileList.add(
        AnimatedContainer(
          alignment: Alignment(projectile.body.x, projectile.body.y),
          duration: Duration(milliseconds: 0),
          child: projectile.displayProjectile(),
        ),
      );
    }

    return Stack(
      children: widgetProjectileList,
    );
  }
}
