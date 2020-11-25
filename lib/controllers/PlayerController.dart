import 'dart:async';
import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/obstacles/EnemyController.dart';
import 'package:corona_bot/controllers/obstacles/PlatformController.dart';
import 'package:corona_bot/controllers/obstacles/ProjectileController.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/PlayerModel.dart';
import 'package:corona_bot/views/PlayerView.dart';
import 'package:flutter/material.dart';

class PlayerController extends ChangeNotifier {
  PlayerModel _model;
  PlayerView _view;

  Body _body;

  // Variables to deal with gravity
  double _time = 0.0;
  double _height = 0.0;
  double _initialHeight;

  // Variables used for the projectiles
  List<ProjectileController> _projectileList = List();
  int _aliveProjectile = 0;
  int _maxProjectile = 3;
  bool _firstShoot = false;

  // Timers
  Timer _projectilesTimer;
  Timer _jumpTimer;
  Timer _fallTimer;
  Stopwatch _redPotTimer = Stopwatch();
  Stopwatch _bluePotTimer = Stopwatch();

  bool _pause = false;

  // Constants
  double _pixelWidth;
  double _pixelHeight;
  double _lifeWidth;

  PlayerController(BuildContext context) {
    _pixelWidth = 2.0 / MediaQuery.of(context).size.width;
    _pixelHeight = 2.0 / (MediaQuery.of(context).size.height * 5.0 / 7.0);
    _lifeWidth = MediaQuery.of(context).size.width / 3.0;

    _model = new PlayerModel();
    _view = new PlayerView();

    double w = MediaQuery.of(context).size.width / 14.0;
    double h = (MediaQuery.of(context).size.height * 5.0 / 7.0) / 5;
    _body = new Body(
      width: w,
      height: h,
      x: 0.0,
      y: 1.0,
    );
  }

  // Deal with timers ----------------------------------------------------------

  // Stop all timers
  void end() {
    if (_projectilesTimer != null) _projectilesTimer.cancel();
    if (_jumpTimer != null) _jumpTimer.cancel();
    if (_fallTimer != null) _fallTimer.cancel();
  }

  set pause(bool value) => _pause = value;

  // Movement related functions ------------------------------------------------

  void moveRight() {
    _model.moveRight();
    for (ProjectileController projectile in _projectileList) {
      projectile.moveRight();
    }
  }

  void moveLeft() {
    _model.moveLeft();
    for (ProjectileController projectile in _projectileList) {
      projectile.moveLeft();
    }
  }

  void stopRun() => _model.stopRun();

  double get x => _body.x;

  double get y => _body.y;

  Direction get direction => _model.horizontal;

  // Jump related functions ----------------------------------------------------

  void jump(double velocity, List<PlatformController> platformList) {
    // No double jump allowed
    if (_model.vertical != Direction.STILL) return;

    _time = 0;
    _initialHeight = _body.y;

    _jumpTimer = Timer.periodic(Duration(milliseconds: 50), (_jumpTimer) {
      if (!_pause) {
        _time += 0.035;
        double prevHeight = _height;

        // Gravity equation
        _height = -4.9 * _time * _time + velocity * _time;

        _model.jump = prevHeight < _height ? Direction.UP : Direction.DOWN;
        double speed =
            prevHeight < _height ? _height - prevHeight : prevHeight - _height;

        // Collision detection
        bool collision = false;
        for (PlatformController pt in platformList) {
          // Bump into a platform while jumping up
          if (_model.vertical == Direction.UP &&
              _body.collideVertically(
                  pt.body, _model.vertical, speed, _pixelWidth, _pixelHeight)) {
            collision = true;
            _model.jump = Direction.STILL;
            _height = 0.0;
            _jumpTimer.cancel();
            fall(platformList);
            break;
          }
          // Land onto a platform
          else if (_model.vertical == Direction.DOWN &&
              _body.collideVertically(
                  pt.body, _model.vertical, speed, _pixelWidth, _pixelHeight)) {
            _body.y = (pt.body.getTopBoundary(_pixelHeight) -
                    _body.height * _pixelHeight / 2.0) /
                (1 - _pixelHeight * _body.height / 2.0);
            collision = true;
            _height = 0.0;
            _model.jump = Direction.STILL;
            _jumpTimer.cancel();
            break;
          }
        }

        if (!collision) {
          // Land on the ground
          if (_initialHeight - _height > 1.0) {
            _model.jump = Direction.STILL;
            _body.y = 1.0;
            _height = 0.0;
            _jumpTimer.cancel();
          } else
            _body.y = _initialHeight - _height;
        }

        notifyListeners();
      }
    });
  }

  void fall(List<PlatformController> platformList) {
    jump(0.0, platformList);
  }

  bool isFallingOfPlatform(PlatformController pt) {
    if (_model.horizontal == Direction.RIGHT) {
      // If left part of player is no more on the platform => fall
      if (pt.body.getRightBoundary(_pixelWidth) + SPEED >
              _body.getLeftBoundary(_pixelWidth) &&
          pt.body.getRightBoundary(_pixelWidth) <
              _body.getLeftBoundary(_pixelWidth) &&
          // Here we check that the player is on the platform
          pt.body.getTopBoundary(_pixelHeight) >
              _body.getBottomBoundary(_pixelHeight) - 0.05) {
        return true;
      }
    } else {
      // If right part of player is no more on the platform => fall
      if (pt.body.getLeftBoundary(_pixelWidth) - SPEED <
              _body.getRightBoundary(_pixelWidth) &&
          pt.body.getLeftBoundary(_pixelWidth) >
              _body.getRightBoundary(_pixelWidth) &&
          // Here we check that the player is on the platform
          pt.body.getTopBoundary(_pixelHeight) >
              _body.getBottomBoundary(_pixelHeight) - 0.05) {
        return true;
      }
    }
    return false;
  }

  Direction get vertical => _model.vertical;

  // Shoot related functions ---------------------------------------------------

  void shoot() {
    // Shoot if there is not already _maxProjectile
    if (_aliveProjectile < _maxProjectile) {
      if (!_firstShoot) {
        _firstShoot = true;
        startProjectile(); // start timer
      }
      _projectileList.add(new ProjectileController(
          new Body(
            x: _body.x,
            y: (_body.getBottomBoundary(_pixelHeight) +
                    _body.getTopBoundary(_pixelHeight)) /
                2,
            width: _body.width / 3.0,
            height: _body.height / 3.0,
          ),
          _model.horizontal,
          _bluePotTimer.isRunning));
      _aliveProjectile++;
    }
  }

  void startProjectile() {
    _projectilesTimer =
        Timer.periodic(Duration(milliseconds: 50), (_projectilesTimer) {
      if (!_pause) {
        // Stop the timer to save power
        if (_projectileList.isEmpty) {
          _firstShoot = false;
          _projectilesTimer.cancel();
        }
        for (ProjectileController projectile in _projectileList) {
          projectile.travel();
        }
        notifyListeners();
      }
    });
  }

  Widget displayProjectile(
      List<PlatformController> platformList, List<EnemyController> enemyList) {
    removeCollideProjectiles(platformList, enemyList);
    return _view.displayProjectiles(_projectileList);
  }

  void removeCollideProjectiles(
      List<PlatformController> platformList, List<EnemyController> enemyList) {
    List<ProjectileController> toRemove = [];
    for (ProjectileController projectile in _projectileList) {
      bool collide = false;

      // Collide with a platform
      for (PlatformController pt in platformList) {
        if (projectile.body.collide(pt.body, _pixelWidth, _pixelHeight)) {
          collide = true;
          _aliveProjectile--;
          toRemove.add(projectile);
          break;
        }
      }

      if (!collide) {
        // Collide with an enemy
        for (EnemyController enemy in enemyList) {
          if (projectile.body.collide(enemy.body, _pixelWidth, _pixelHeight)) {
            collide = true;
            _aliveProjectile--;
            toRemove.add(projectile);
            enemy.damage(projectile.freezing);
            break;
          }
        }
      }

      if (!collide) {
        bool outOfScreen = ((projectile.direction == Direction.STILL_RIGHT ||
                    projectile.direction == Direction.RIGHT) &&
                projectile.body.x > 1.1) ||
            ((projectile.direction == Direction.STILL_LEFT ||
                    projectile.direction == Direction.LEFT) &&
                projectile.body.x < -1.1);

        if (outOfScreen) {
          _aliveProjectile--;
          toRemove.add(projectile);
        }
      }
    }
    _projectileList.removeWhere((e) => toRemove.contains(e));
  }

  // Bonuses

  void drinkPotion(String potion) {
    if (potion == GREEN_POTION) {
      _model.heal(0.33);
    } else {
      startPotion(potion);
    }
  }

  void startPotion(String potion) {
    switch (potion) {
      case BLUE_POTION:
        if (_redPotTimer.isRunning) {
          _redPotTimer.reset();
          _redPotTimer.stop();
          _maxProjectile = 3;
        }
        if (_bluePotTimer.isRunning) {
          _bluePotTimer.reset();
        }

        _bluePotTimer.start();
        break;
      case RED_POTION:
        if (_bluePotTimer.isRunning) {
          _bluePotTimer.reset();
          _bluePotTimer.stop();
        }
        if (_redPotTimer.isRunning) {
          _redPotTimer.reset();
        }

        _redPotTimer.start();
        _maxProjectile = 20;
        break;
    }
  }

  // Accessors -----------------------------------------------------------------

  void damage(double dmg) {
    _model.damage(dmg);
  }

  void heal(double life) {
    _model.heal(life);
  }

  double get health => _model.life;

  bool get dead => _model.life <= 0.0;

  Body get body => _body;

  // Display -------------------------------------------------------------------

  Widget displayPlayer() {
    // After 5sec (10sec) the redPot (bluePot) stops
    // We put that here since this function is called every 50ms
    if (_redPotTimer.elapsedMilliseconds > 5000) {
      _redPotTimer.reset();
      _redPotTimer.stop();
      _maxProjectile = 3;
    }
    if (_bluePotTimer.elapsedMilliseconds > 10000) {
      _bluePotTimer.reset();
      _bluePotTimer.stop();
    }

    return _view.displayPlayer(
        _model.sprite,
        _model.vertical,
        _model.horizontal,
        _body.width,
        _body.height,
        _redPotTimer.isRunning,
        _bluePotTimer.isRunning);
  }

  Widget displayPlayerLife() {
    return _view.displayLife(_lifeWidth, _model.life);
  }
}
