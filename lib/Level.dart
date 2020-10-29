import 'dart:async';
import 'package:flutter/material.dart';
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
          if (_player.body
              .collideHorizontally(pt.body, _pixelWidth, _pixelHeight)) {
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
          if (_player.body
              .collideHorizontally(pt.body, _pixelWidth, _pixelHeight)) {
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

  // TODO : modify
  bool isFalling(Platform pt, String direction) {
    if (direction == "right") {
      if (pt.posX + ((pt.width / 2) * _pixelWidth) + _speed >
              -_pixelWidth * 80 * 0.73 &&
          pt.posX + ((pt.width / 2) * _pixelWidth) - _speed <
              -_pixelWidth * 80 * 0.73) {
        return true;
      }
    } else {
      if (pt.posX - ((pt.width / 2) * _pixelWidth) - _speed <
              _pixelWidth * 80 * 0.73 &&
          pt.posX - ((pt.width / 2) * _pixelWidth) + _speed >
              _pixelWidth * 80 * 0.73) {
        return true;
      }
    }
    return false;
  }
}
