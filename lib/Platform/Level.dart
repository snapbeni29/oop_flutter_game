import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Platform/Platform.dart';
import 'package:flutter_app_mario/Player.dart';
import 'package:flutter_app_mario/utils/Limits.dart';

class Level extends ChangeNotifier {
  double _posX = 0.7;
  double _posY = 0.5;

  double _speed = 0.025;

  Player _player;

  bool _midRun = false;

  List<Platform> _platformList = List();

  Level(Player player) {
    this._player = player;

    _platformList.add(Platform(
      width: 100,
      height: 100,
      posX: 0.8,
      posY: 1,
    ));

    /*_platformList.add(Platform(
      width: 200,
      height: 40,
      posX: 0.4,
      posY: -0.5,
    ));*/
  }

  Widget displayLevel() {
    List<Widget> widgetList = List();
    for (Platform pf in _platformList) {
      widgetList.add(pf.displayPlatform());
    }

    widgetList.add(
      AnimatedContainer(
        alignment: Alignment(_player.posX, _player.posY),
        duration: Duration(milliseconds: 0),
        child: _player.displayPlayer(),
      ),
    );

    widgetList.add(_player.displayProjectile());

    return Stack(
      children: widgetList,
    );
  }

  void moveLeft(BuildContext context) {
    if (_player.direction == 'right' && _midRun) return;

    double pixelWidth = 2 / MediaQuery.of(context).size.width;
    double pixelHeight = 2 / ((MediaQuery.of(context).size.height) * 5 / 7);

    bool collision = false;

    _player.direction = "left";
    _midRun = true;
    _player.moveLeft();

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_midRun) {
        for (Platform pt in _platformList) {
          if (collide(pixelWidth, pixelHeight, pt, _player.direction)) {
            stopMoveLeft();
            timer.cancel();
            notifyListeners();
            collision = true;
            break;
          }
        }
        if (!collision) {
          for (Platform pt in _platformList) {
            pt.moveLeft(_speed);
            if (isFalling(pixelWidth, pixelHeight, pt, _player.direction)) {
              // We remove the platform that we are on because we can't fall on it
              List<Platform> newList = List.from(_platformList);
              newList.remove(pt);
              _player.fall(pixelHeight, pixelWidth, newList);
            }
          }
          _posX += _speed;
          notifyListeners();
        }
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void stopMoveLeft() {
    if (_player.direction == "left") {
      _midRun = false;
      _player.stopRunLeft();
    }
  }

  void moveRight(BuildContext context) {
    double pixelWidth = 2 / MediaQuery.of(context).size.width;
    double pixelHeight = 2 / ((MediaQuery.of(context).size.height) * 5 / 7);

    if (_player.direction == "left" && _midRun) return;

    bool collision = false;

    _player.direction = "right";
    _midRun = true;
    _player.moveRight();

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_midRun) {
        for (Platform pt in _platformList) {
          if (collide(pixelWidth, pixelHeight, pt, _player.direction)) {
            stopMoveRight();
            timer.cancel();
            notifyListeners();
            collision = true;
            break;
          }
        }
        if (!collision) {
          for (Platform pt in _platformList) {
            pt.moveRight(_speed);
            if (isFalling(pixelWidth, pixelHeight, pt, _player.direction)) {
              // We remove the platform that we are on because we can't fall on it
              List<Platform> newList = List.from(_platformList);
              newList.remove(pt);
              _player.fall(pixelHeight, pixelWidth, newList);
            }
          }
          _posX -= _speed;
          notifyListeners();
        }
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void stopMoveRight() {
    if (_player.direction == "right") {
      _midRun = false;
      _player.stopRunRight();
    }
  }

  void jump(double velocity, BuildContext context) {
    double pixelWidth = 2 / MediaQuery.of(context).size.width;
    double pixelHeight = 2 / ((MediaQuery.of(context).size.height) * 5 / 7);
    _player.jump(velocity, _platformList, pixelWidth, pixelHeight);
  }

  void fall(
      double pixelHeight, double pixelWidth, List<Platform> platformList) {
    _player.fall(pixelHeight, pixelWidth, platformList);
  }

  bool collide(
      double pixelWidth, double pixelHeight, Platform pt, String direction) {
    /*
    IF player right side is AFTER the wall begin &&
    player left side is before end of the wall we collide
     */
    if (direction == "right") {
      if (getLeftBoundarie(pt.posX, pt.width, pixelWidth) <
              getPlayerRightBoundarie(pixelWidth) + 0.02 &&
          getRightBoundarie(pt.posX, pt.width, pixelWidth) >
              getPlayerRightBoundarie(pixelWidth)) {
        // No collision top of block is under the player
        if (getTopBoundarie(pt.posY, pt.height, pixelHeight) >
            getPlayerBottomBoundarie(_player.posY, pixelHeight) - 0.05) {
          return false;
        }
        // No collision bottom of block is above the head of the character
        if (getBottomBoundarie(pt.posY, pt.height, pixelHeight) <
            getPlayerTopBoundarie(_player.posY, pixelHeight) - 0.05) {
          return false;
        }
        return true;
      }
      return false;
    } else {
      if (getRightBoundarie(pt.posX, pt.width, pixelWidth) >
              -getPlayerRightBoundarie(pixelWidth) -0.02 &&
          getLeftBoundarie(pt.posX, pt.width, pixelWidth) <
              -getPlayerRightBoundarie(pixelWidth)) {
        // No collision top of block is under the player
        if (getTopBoundarie(pt.posY, pt.height, pixelHeight) >
            getPlayerBottomBoundarie(_player.posY, pixelHeight) - 0.05) {
          return false;
        }
        // No collision bottom of block is above the head of the character
        if (getBottomBoundarie(pt.posY, pt.height, pixelHeight) <
            getPlayerTopBoundarie(_player.posY, pixelHeight) - 0.05) {
          return false;
        }
        return true;
      }
      return false;
    }
  }

  bool isFalling(
      double pixelWidth, double pixelHeight, Platform pt, String direction) {
    if (direction == "right") {
      // If at next step the left part of player is no more on the platform we fall
      if (getRightBoundarie(pt.posX, pt.width, pixelWidth) + _speed >
              getPlayerLeftBoundarie(pixelWidth) &&
          getRightBoundarie(pt.posX, pt.width, pixelWidth) <
              getPlayerLeftBoundarie(pixelWidth) &&
          // Here we check that the player is on the platform
          getTopBoundarie(pt.posY, pt.height, pixelHeight) >
              getPlayerBottomBoundarie(_player.posY, pixelHeight) - 0.05) {
        return true;
      }
    } else {
      // If at next step the right part of player is no more on the platform we fall
      if (getLeftBoundarie(pt.posX, pt.width, pixelWidth) - _speed <
              getPlayerRightBoundarie(pixelWidth) &&
          getLeftBoundarie(pt.posX, pt.width, pixelWidth) >
              getPlayerRightBoundarie(pixelWidth) &&
          // Here we check that the player is on the platform
          getTopBoundarie(pt.posY, pt.height, pixelHeight) >
              getPlayerBottomBoundarie(_player.posY, pixelHeight) - 0.05) {
        return true;
      }
    }
    return false;
  }
}
