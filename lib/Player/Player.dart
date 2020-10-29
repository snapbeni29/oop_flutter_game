import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Body.dart';
import 'package:flutter_app_mario/Platform/Platform.dart';
import 'package:flutter_app_mario/Player/Projectile.dart';

class Player extends ChangeNotifier {
  // Variables that define an instance of Player
  Body _body;
  String _direction = "right";
  String _verticalDirection = "up";
  bool _midRun = false;
  bool _midJump = false;
  bool _midFall = false;
  int _runPos = 0;

  // Variables to deal with gravity
  double _time = 0.0;
  double _height = 0.0;
  double _initialHeight;

  // Variables used for the projectiles
  List<Projectile> _projectileList = List();
  int _aliveProjectile = 0;
  int _maxProjectile = 3;
  bool _firstShoot = false;

  double _pixelWidth;
  double _pixelHeight;

  Player(BuildContext context) {
    _pixelWidth = 2.0 / MediaQuery.of(context).size.width;
    _pixelHeight = 2.0 / (MediaQuery.of(context).size.height * 5.0 / 7.0);

    double w = MediaQuery.of(context).size.width / 10.0;
    double h = (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0;

    _body = new Body(
      width: w,
      height: h,
      x: 0.0,
      y: (1.0 - h * _pixelHeight / 2.0) / (1.0 - _pixelHeight * h / 2.0),
    );
  }

  // Player movement ----------------------------------------------------------

  void stopRun() {
    _midRun = false;
  }

  void moveLeft() {
    _direction = "left";
    _midRun = true;
  }

  void moveRight() {
    _direction = "right";
    _midRun = true;
  }

  void jump(double velocity, List<Platform> platformList) {
    // No double jump allowed --currently--
    if (_midJump) return;

    _time = 0;
    _initialHeight = _body.y;
    _midJump = true;

    bool collision = false;

    Timer.periodic(Duration(milliseconds: 30), (timer) {
      _time += 0.025;
      double prevHeight = _height;

      // Gravity equation
      _height = -4.9 * _time * _time + velocity * _time;

      _verticalDirection = prevHeight < _height ? "up" : "down";
      double speed =
          prevHeight < _height ? _height - prevHeight : prevHeight - _height;

      // Collision detection with a platform
      collision = false;
      for (Platform pt in platformList) {
        // Bump into a platform while jumping up
        if (_verticalDirection == "up" &&
            _body.collideVertically(pt.body, _verticalDirection, speed,
                _pixelWidth, _pixelHeight)) {
          _midJump = false;
          collision = true;
          _height = 0.0;
          print(pt.posY);
          timer.cancel();
          fall(platformList);
          break;
        }
        // Land onto a platform
        else if (_verticalDirection == "down" &&
            _body.collideVertically(pt.body, _verticalDirection, speed,
                _pixelWidth, _pixelHeight)) {
          _midJump = false;
          _body.y = (getTopBoundary(pt.posY, pt.height, _pixelHeight) -
                  _body.height * _pixelHeight / 2.0) /
              (1 - _pixelHeight * _body.height / 2.0);
          collision = true;
          _height = 0.0;
          timer.cancel();
          break;
        }
      }

      if (!collision) {
        // Land on the ground
        if (_initialHeight - _height > 1.0) {
          _midJump = false;
          _body.y = (1.0 - _body.height * _pixelHeight / 2.0) /
              (1 - _pixelHeight * _body.height / 2.0);
          _height = 0.0;
          timer.cancel();
        } else
          body.y = _initialHeight - _height;
      }

      notifyListeners();
    });
  }

  void fall(List<Platform> platformList) {
    _time = 0;
    _initialHeight = _body.y;
    _midFall = true;
    _verticalDirection = "down";

    bool collision = false;

    Timer.periodic(Duration(milliseconds: 30), (timer) {
      _time += 0.025;
      double prevHeight = _height;

      // Gravity equation
      _height = -4.9 * _time * _time;

      double speed =
          prevHeight < _height ? _height - prevHeight : prevHeight - _height;

      // Collision detection
      collision = false;
      for (Platform pt in platformList) {
        // Land onto a platform
        if (_verticalDirection == "down" &&
            _body.collideVertically(pt.body, _verticalDirection, speed,
                _pixelWidth, _pixelHeight)) {
          _midFall = false;
          _body.y = (getTopBoundary(pt.posY, pt.height, _pixelHeight) -
                  _body.height * _pixelHeight / 2.0) /
              (1 - _pixelHeight * _body.height / 2.0);
          collision = true;
          _height = 0.0;
          timer.cancel();
          break;
        }
      }

      if (!collision) {
        // Land on the ground
        if (_initialHeight - _height > 1.0) {
          _midFall = false;
          _body.y = (1.0 - _body.height * _pixelHeight / 2.0) /
              (1 - _pixelHeight * _body.height / 2.0);
          _height = 0.0;
          timer.cancel();
        } else
          _body.y = _initialHeight - _height;
      }

      notifyListeners();
    });
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
        width: _body.width,
        height: _body.height,
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
          width: _body.width,
          height: _body.height,
          child: FittedBox(
            fit: BoxFit.fill,
            child: img,
          ),
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
        direction: _direction,
        body: new Body(
          // TODO : these double values should be generic
          x: _direction == 'right' ? _body.x + 0.015 : _body.x - 0.015,
          y: _body.y - 0.25,
          width: _body.width / 4,
          height: _body.height / 4,
        ),
      ));
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

  // Get & Set functions ------------------------------------------------------

  double get posX => _body.x;

  double get posY => _body.y;

  String get direction => _direction;

  Body get body => _body;
}
