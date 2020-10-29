import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Platform/Platform.dart';
import 'package:flutter_app_mario/Projectile.dart';
import 'package:flutter_app_mario/utils/Limits.dart';

class Player extends ChangeNotifier {
  String _direction = "right";
  bool _midRun = false;
  bool _midJump = false;
  bool _midFall = false;

  double _playerX = 0;
  double _playerY = 1.06;

  int _runPos = 0;

  double _time = 0;
  double _height = 0;
  double _initialHeight;

  List<Projectile> _projectileList = List();
  int _aliveProjectile = 0;
  int _maxProjectile = 3;
  bool _firstShoot = false;

  // Player movement ----------------------------------------------------------

  void jump(double velocity, List<Platform> platformList, double pixelWidth,
      double pixelHeight) {
    // No double jump allowed --currently--
    if (_midJump) return;

    if (velocity <= 0.0) velocity = 4.0;

    _time = 0;
    _initialHeight = _playerY;
    _midJump = true;

    Timer.periodic(Duration(milliseconds: 40), (timer) {
      _time += 0.05;
      // Gravity equation
      _height = -4.9 * _time * _time + velocity * _time;

      // Collision detection
      for (Platform pt in platformList) {
        if (isOnPlatX(pt, pixelWidth)) {
          if (getPlayerTopBoundarie(posY, pixelHeight) <
                  getBottomBoundarie(pt.posY, pt.height, pixelHeight) &&
              getPlayerTopBoundarie(posY, pixelHeight) >
                  getTopBoundarie(pt.posY, pt.height, pixelHeight)) {
            debugPrint("coucou fall");
            _midJump = false;
            timer.cancel();
            fall(pixelHeight, pixelWidth, platformList);
            break;
          } else if (getPlayerBottomBoundarie(posY, pixelHeight)>
              getTopBoundarie(pt.posY, pt.height, pixelHeight) - 0.05) {
            debugPrint("coucou atterissage");
            _midJump = false;
            _playerY = (getTopBoundarie(pt.posY, pt.height, pixelHeight) - 35 * pixelHeight) / (1 - 40 * pixelHeight);
            timer.cancel();
            break;
          } else {
            // Update
            _playerY = _initialHeight - _height;
            notifyListeners();
          }
        } else {
          if (_initialHeight - _height > 1 + 0.1 * 80 * pixelHeight) {
            debugPrint("coucou");
            _midJump = false;
            _playerY = 1 + 0.09 * 80 * pixelHeight * 7 / 5;
            timer.cancel();
            break;
          } else {
            // Update
            _playerY = _initialHeight - _height;
            notifyListeners();
          }
        }
      }
      notifyListeners();
    });
  }

  void fall(
      double pixelHeight, double pixelWidth, List<Platform> platformList) {
    _time = 0;
    _initialHeight = _playerY;
    _midFall = true;

    Timer.periodic(Duration(milliseconds: 60), (timer) {
      _time += 0.05;
      // Gravity equation
      _height = -4.9 * _time * _time;

      // Collision detection
      if (platformList.isEmpty) {
        if (_initialHeight - _height > 1 + 0.1 * 80 * pixelHeight) {
          _midFall = false;
          _playerY = 1 + 0.1 * 80 * pixelHeight;
          timer.cancel();
        } else {
          // Update
          _playerY = _initialHeight - _height;
          notifyListeners();
        }
      } else {
        for (Platform pt in platformList) {
          if (_initialHeight - _height >
                  pt.posY - pt.height * pixelHeight * 7 / 5 &&
              isOnPlatX(pt, pixelWidth)) {
            _playerY = pt.posY -
                pt.height * pixelHeight * 7 / 5 +
                0.09 * 7 / 5 * 80 * pixelHeight;
            _midFall = false;
            _playerY = pt.posY -
                pt.height * pixelHeight * 7 / 5 +
                0.09 * 7 / 5 * 80 * pixelHeight;
            timer.cancel();
            break;
          } else if (_initialHeight - _height > 1 + 0.1 * 80 * pixelHeight) {
            _midFall = false;
            _playerY = 1 + 0.1 * 80 * pixelHeight;
            timer.cancel();
          } else {
            // Update
            _playerY = _initialHeight - _height;
            notifyListeners();
          }
        }
      }
      notifyListeners();
    });
  }

  void stopRunLeft() {
    _midRun = false;
  }

  void moveLeft() {
    _midRun = true;
  }

  void stopRunRight() {
    _midRun = false;
  }

  void moveRight() {
    _midRun = true;
  }

  Widget displayPlayer() {
    Image img; // which sprite to display
    if (_midJump) {
      img = Image.asset('images/Jump (5).png');
    } else if (_midFall) {
      img = Image.asset('images/Jump (9).png');
    } else if (_midRun) {
      // Run animation : a different sprite in the pattern
      _runPos = (_runPos + 1) % 8;
      img = Image.asset('images/Run (' + (_runPos + 1).toString() + ').png');
    } else {
      img = Image.asset('images/Idle (1).png');
    }

    // The sprites are looking right initially
    if (_direction == 'right') {
      return Container(
        width: 80.0,
        height: 80.0,
        child: img,
      );
    }
    // When going left, we have to rotate the sprite by pi
    else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: 80.0,
          height: 80.0,
          child: img,
        ),
      );
    }
  }

  //  Projectile interactions -------------------------------------------------

  void shoot() {
    // Shoot if there is not already _maxProjectile
    if (_aliveProjectile < _maxProjectile) {
      if (!_firstShoot) {
        _firstShoot = true;
        startProjectile(); // start timer
      }
      _projectileList.add(Projectile(
          projectileX:
              _direction == 'right' ? _playerX + 0.015 : _playerX - 0.015,
          projectileY: _playerY - 0.13,
          direction: _direction));
      _aliveProjectile++;
    }
  }

  void startProjectile() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      // Stop the timer to save power
      if (_projectileList.isEmpty) {
        _firstShoot = false;
        timer.cancel();
      }
      for (Projectile projectile in _projectileList) {
        if (projectile.getDirection == "right") {
          projectile.moveRight();
        } else {
          projectile.moveLeft();
        }
      }
      notifyListeners();
    });
  }

  Widget displayProjectile() {
    if (_projectileList.isEmpty) return Container();

    List<Widget> widgetProjectileList = List();
    for (int i = 0; i < _projectileList.length; i++) {
      if (_projectileList.isEmpty) {
        break;
      }

      bool outOfScreen = (_projectileList[i].direction == "right" &&
              _projectileList[i].posX > 1.1) ||
          (_projectileList[i].direction == "left" &&
              _projectileList[i].posX < -1.1);

      if (outOfScreen) {
        _aliveProjectile--;
        _projectileList.remove(_projectileList[i]);
      } else {
        widgetProjectileList.add(AnimatedContainer(
          alignment:
              Alignment(_projectileList[i].posX, _projectileList[i].posY),
          duration: Duration(milliseconds: 0),
          child: _projectileList[i].displayProjectile(),
        ));
      }
    }

    return Stack(
      children: widgetProjectileList,
    );
  }

  // Check that if a player is on the top of a platform according to X axis
  bool isOnPlatX(Platform pt, pixelWidth) {
    return (getLeftBoundarie(pt.posX, pt.width, pixelWidth) <
            getPlayerRightBoundarie(pixelWidth) &&
        getRightBoundarie(pt.posX, pt.width, pixelWidth) >
            getPlayerLeftBoundarie(pixelWidth));
  }

  // Get & Set functions ------------------------------------------------------

  double get posX => _playerX;

  double get posY => _playerY;

  // ignore: unnecessary_getters_setters
  String get direction => _direction;

  // ignore: unnecessary_getters_setters
  set direction(String d) => _direction = d;
}
