import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Body.dart';
import 'package:flutter_app_mario/Platform/Layout.dart';
import 'package:flutter_app_mario/Platform/Platform.dart';
import 'package:flutter_app_mario/Player/Player.dart';

class Level extends ChangeNotifier {
  //double _posX = 0.7;
  //double _posY = 0.5;

  double _speed = 0.025;
  Player _player;
  bool _midRun = false;

  double _pixelWidth;
  double _pixelHeight;

  List<Platform> _platformList = List();

  Level(Player player, BuildContext context) {
    _player = player;
    _platformList = Layout().create(context);
    _pixelWidth = 2.0 / MediaQuery.of(context).size.width;
    _pixelHeight = 2.0 / (MediaQuery.of(context).size.height * 5.0 / 7.0);
  }

  Widget displayLevel() {
    List<Widget> widgetList = List();
    for (Platform pf in _platformList) {
      widgetList.add(pf.displayPlatform());
    }

    widgetList.add(
      Stack(
        children: [
          AnimatedContainer(
            alignment: Alignment(_player.posX, _player.posY),
            duration: Duration(milliseconds: 0),
            child: _player.displayPlayer(),
          ),
          _player.displayProjectile(),
        ],
      ),
    );

    return Stack(
      children: widgetList,
    );
  }

  void moveLeft() {
    if (_player.direction == 'right' && _midRun) return;

    _midRun = true;
    _player.moveLeft();

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_midRun) {
        // Collision with a platform
        bool collision = false;
        for (Platform pt in _platformList) {
          if (_player.body.collideHorizontally(pt.body, _player.direction,
              _speed, _pixelWidth, _pixelHeight)) {
            stopMoveLeft();
            timer.cancel();
            notifyListeners();
            collision = true;
            break;
          }
        }

        // Walk off edge
        if (!collision) {
          for (Platform pt in _platformList) {
            pt.moveLeft(_speed);
            if (isFalling(pt, _player.direction)) {
              _player.fall(_platformList);
            }
          }
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
      _player.stopRun();
    }
  }

  void moveRight() {
    if (_player.direction == "left" && _midRun) return;

    _midRun = true;
    _player.moveRight();

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_midRun) {
        // Collision with a platform
        bool collision = false;
        for (Platform pt in _platformList) {
          if (_player.body.collideHorizontally(pt.body, _player.direction,
              _speed, _pixelWidth, _pixelHeight)) {
            //debugPrint(pt.height.toString());
            stopMoveRight();
            timer.cancel();
            notifyListeners();
            collision = true;
            break;
          }
        }

        // Walk off edge
        if (!collision) {
          for (Platform pt in _platformList) {
            pt.moveRight(_speed);
            if (isFalling(pt, _player.direction)) {
              _player.fall(_platformList);
            }
          }
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
      _player.stopRun();
    }
  }

  void jump(double velocity) {
    _player.jump(velocity, _platformList);
  }

  void fall() {
    _player.fall(_platformList);
  }

  bool isFalling(Platform pt, String direction) {
    if (direction == "right") {
      // If left part of player is no more on the platform => fall
      if (getRightBoundary(pt.posX, pt.width, _pixelWidth) + _speed >
              getLeftBoundary(_player.posX, _player.body.width, _pixelWidth) &&
          getRightBoundary(pt.posX, pt.width, _pixelWidth) <
              getLeftBoundary(_player.posX, _player.body.width, _pixelWidth) &&
          // Here we check that the player is on the platform
          getTopBoundary(pt.posY, pt.height, _pixelHeight) >
              getBottomBoundary(
                      _player.posY, _player.body.height, _pixelHeight) -
                  0.05) {
        return true;
      }
    } else {
      // If right part of player is no more on the platform => fall
      if (getLeftBoundary(pt.posX, pt.width, _pixelWidth) - _speed <
              getRightBoundary(_player.posX, _player.body.width, _pixelWidth) &&
          getLeftBoundary(pt.posX, pt.width, _pixelWidth) >
              getRightBoundary(_player.posX, _player.body.width, _pixelWidth) &&
          // Here we check that the player is on the platform
          getTopBoundary(pt.posY, pt.height, _pixelHeight) >
              getBottomBoundary(
                      _player.posY, _player.body.height, _pixelHeight) -
                  0.05) {
        return true;
      }
    }
    return false;
  }
}
