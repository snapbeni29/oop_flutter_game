import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Constants/constants.dart';
import 'package:flutter_app_mario/Platform/Platform.dart';
import 'package:flutter_app_mario/Player.dart';

class Level extends ChangeNotifier {
  double screenWidth = 1000;
  double screenHeight = 500;

  double _posX = 0.5;
  double _posY = 0.5;

  Player _player;

  bool _midRun = false;

  List<Platform> _platformList = List();

  Level(Player player) {
    debugPrint("hello");
    this._player = player;
  }

  Widget displayLevel() {
    _platformList.add(Platform(
      width: screenWidth / 5,
      height: screenHeight / 10,
      posX: _posX,
      posY: _posY,
    ));

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

    _player.direction = "left";
    _midRun = true;
    _player.moveLeft();

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_midRun) {
        for (Platform pt in _platformList) {
          pt.moveLeft();
        }
        _posX += 0.015;
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


    if (_player.direction == "left" && _midRun) return;

    _player.direction = "right";
    _midRun = true;

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_midRun) {
        for (Platform pt in _platformList) {
          if(collide(pixelWidth, pt, _player.direction)){
            stopMoveRight();
            timer.cancel();
            notifyListeners();
          }
          pt.moveRight();
          _player.moveRight();
        }
        _posX -= 0.015;
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

  bool collide(double pixelWidth, Platform pt, String direction){
    if(direction == "right") {
      if ((pt.posX - pt.width * pixelWidth) - 0.02 < 0) {
        return true;
      }
      return false;
    }
    else{
      if ((pt.posX + pt.width * pixelWidth) + 0.02 > 0) {
        return true;
      }
      return false;
    }
  }

}
