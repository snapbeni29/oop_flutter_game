import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Platform/Platform.dart';
import 'package:flutter_app_mario/Player.dart';

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
      width: 200,
      height: 100,
      posX: 0.8,
      posY: 1,
    ));

    /*_platformList.add(Platform(
      width: 100,
      height: 10,
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

  void moveLeft(BuildContext context) {
    if (_player.direction == 'right' && _midRun) return;

    double pixelWidth = 2 / MediaQuery.of(context).size.width;
    double pixelHeight = 2 / (MediaQuery.of(context).size.height * 5 / 7);

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
            break;
          }
          if (isFalling(pixelWidth, pt, _player.direction)) {
            _player.fall(pixelHeight);
          }
          pt.moveLeft(_speed);
        }
        _posX += _speed;
        notifyListeners();
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
    double pixelHeight = 2 / (MediaQuery.of(context).size.height * 5 / 7);

    if (_player.direction == "left" && _midRun) return;

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
            break;
          }
          if (isFalling(pixelWidth, pt, _player.direction)) {
            _player.fall(pixelHeight);
          }
          pt.moveRight(_speed);
        }
        _posX -= _speed;
        notifyListeners();
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
    double pixelHeight = 2 / (MediaQuery.of(context).size.height * 5 / 7);
    _player.jump(velocity, _platformList, pixelWidth, pixelHeight);
  }

  void fall(double pixelHeight) {
    _player.fall(pixelHeight);
  }

  bool collide(
      double pixelWidth, double pixelHeight, Platform pt, String direction) {
    if (direction == "right") {
      if (pt.posX - ((pt.width / 2) * pixelWidth) < pixelWidth * 80 * 0.83 &&
          pt.posX + ((pt.width / 2) * pixelWidth) > pixelWidth * 80 * 0.83) {
        if (_player.posY - 0.09 * 7 / 5 * 80 * pixelHeight >
            pt.posY - ((pt.height) * pixelHeight)) {
          return true;
        }
      }
      return false;
    } else {
      if (pt.posX + ((pt.width / 2) * pixelWidth) > -pixelWidth * 80 * 0.83 &&
          pt.posX - ((pt.width / 2) * pixelWidth) < -pixelWidth * 80 * 0.83) {
        if (_player.posY - 0.09 * 7 / 5 * 80 * pixelHeight >
            pt.posY - ((pt.height) * pixelHeight)) {
          return true;
        }
      }
      return false;
    }
  }

  bool isFalling(double pixelWidth, Platform pt, String direction) {
    if (direction == "right") {
      if (pt.posX + ((pt.width / 2) * pixelWidth) + _speed >
              -pixelWidth * 80 * 0.73 &&
          pt.posX + ((pt.width / 2) * pixelWidth) - _speed <
              -pixelWidth * 80 * 0.73) {
        return true;
      }
    } else {
      if (pt.posX - ((pt.width / 2) * pixelWidth) - _speed <
              pixelWidth * 80 * 0.73 &&
          pt.posX - ((pt.width / 2) * pixelWidth) + _speed >
              pixelWidth * 80 * 0.73) {
        return true;
      }
    }

    return false;
  }
}
