import 'dart:async';
import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/ShooterMixin.dart';
import 'package:corona_bot/controllers/obstacles/BossController.dart';
import 'package:corona_bot/controllers/obstacles/EnemyController.dart';
import 'package:corona_bot/controllers/obstacles/PlatformController.dart';
import 'package:corona_bot/controllers/obstacles/ProjectileController.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/PlayerModel.dart';
import 'package:corona_bot/views/PlayerView.dart';
import 'package:flutter/material.dart';

class PlayerController with ShooterMixin {
  PlayerModel _model;
  PlayerView _view;

  Body _body;
  double _lifeWidth;
  bool _pause = false;

  // Variables from the shop
  String _hat;
  bool _doubleJump;
  bool secondJump = false;
  int _defaultProjectiles;

  // Variables to deal with gravity
  double _time = 0.0;
  double _height = 0.0;
  double _initialHeight;

  // Timers
  Timer _projectilesTimer;
  Timer _jumpTimer;
  Timer _fallTimer;
  Stopwatch _redPotTimer = Stopwatch();
  Stopwatch _bluePotTimer = Stopwatch();

  PlayerController(
      BuildContext context, this._hat, this._doubleJump, int maxProjectiles) {
    pixelWidth = 2.0 / MediaQuery.of(context).size.width;
    pixelHeight = 2.0 / (MediaQuery.of(context).size.height * 5.0 / 7.0);
    _lifeWidth = MediaQuery.of(context).size.width / 3.0;

    _model = new PlayerModel();
    _view = new PlayerView();

    maxProjectile = maxProjectiles;
    _defaultProjectiles = maxProjectiles;

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

  /// Stop all timers
  void end() {
    if (_projectilesTimer != null) _projectilesTimer.cancel();
    if (_jumpTimer != null) _jumpTimer.cancel();
    if (_fallTimer != null) _fallTimer.cancel();
  }

  set setPause(bool value) => _pause = value;

  // Movement related functions ------------------------------------------------

  void moveRight() {
    _model.moveRight();
    for (ProjectileController projectile in projectileList) {
      projectile.moveRight();
    }
  }

  void moveLeft() {
    _model.moveLeft();
    for (ProjectileController projectile in projectileList) {
      projectile.moveLeft();
    }
  }

  void stopRun() => _model.stopRun();

  double get x => _body.x;

  double get y => _body.y;

  Direction get direction => _model.horizontal;

  // Jump related functions ----------------------------------------------------

  void jump(double velocity, List<PlatformController> platformList) {
    if (!_doubleJump && _model.vertical != Direction.STILL) return;
    if (_doubleJump && secondJump) return;
    if (_doubleJump && _model.vertical == Direction.UP ||
        _model.vertical == Direction.DOWN) {
      secondJump = true;
    }

    if (_jumpTimer != null) _jumpTimer.cancel();

    _time = 0;
    _initialHeight = _body.y;
    _height = 0;

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
          // Check only the platforms on screen
          if (pt.body.x < onScreen && pt.body.x > -onScreen) {
            // Bump into a platform while jumping up
            if (_model.vertical == Direction.UP &&
                _body.collideVertically(
                    pt.body, _model.vertical, speed, pixelWidth, pixelHeight)) {
              collision = true;
              _model.jump = Direction.STILL;
              secondJump = false;
              _height = 0.0;
              _jumpTimer.cancel();
              fall(platformList);
              break;
            }
            // Land onto a platform
            else if (_model.vertical == Direction.DOWN &&
                _body.collideVertically(
                    pt.body, _model.vertical, speed, pixelWidth, pixelHeight)) {
              _body.y = (pt.body.getTopBoundary(pixelHeight) -
                      _body.height * pixelHeight / 2.0) /
                  (1 - pixelHeight * _body.height / 2.0);
              collision = true;
              _height = 0.0;
              _model.jump = Direction.STILL;
              secondJump = false;
              _jumpTimer.cancel();
              break;
            }
          }
        }

        if (!collision) {
          // Land on the ground
          if (_initialHeight - _height > 1.0) {
            _model.jump = Direction.STILL;
            secondJump = false;
            _body.y = 1.0;
            _height = 0.0;
            _jumpTimer.cancel();
          } else
            _body.y = _initialHeight - _height;
        }
      }
    });
  }

  void fall(List<PlatformController> platformList) {
    jump(0.0, platformList);
  }

  /// Checks if the player is falling from a platform, to start fall().
  bool isFallingOfPlatform(PlatformController pt) {
    if (_model.vertical == Direction.STILL) {
      if (_model.horizontal == Direction.RIGHT) {
        // If left part of player is no more on the platform => fall
        if (pt.body.getRightBoundary(pixelWidth) + SPEED >
                _body.getLeftBoundary(pixelWidth) &&
            pt.body.getRightBoundary(pixelWidth) <
                _body.getLeftBoundary(pixelWidth) &&
            // Here we check that the player is on the platform
            pt.body.getTopBoundary(pixelHeight) >
                _body.getBottomBoundary(pixelHeight) - 0.05) {
          return true;
        }
      } else {
        // If right part of player is no more on the platform => fall
        if (pt.body.getLeftBoundary(pixelWidth) - SPEED <
                _body.getRightBoundary(pixelWidth) &&
            pt.body.getLeftBoundary(pixelWidth) >
                _body.getRightBoundary(pixelWidth) &&
            // Here we check that the player is on the platform
            pt.body.getTopBoundary(pixelHeight) >
                _body.getBottomBoundary(pixelHeight) - 0.05) {
          return true;
        }
      }
      return false;
    }

    return false;
  }

  Direction get vertical => _model.vertical;

  // Shoot related functions ---------------------------------------------------

  void shoot() {
    shootMixin(
      _model.horizontal,
      _bluePotTimer.isRunning,
      new Body(
        x: _body.x,
        y: (_body.getBottomBoundary(pixelHeight) +
                _body.getTopBoundary(pixelHeight)) /
            2,
        width: _body.width / 3.0,
        height: _body.height / 3.0,
      ),
    );
  }

  void startProjectile() {
    _projectilesTimer =
        Timer.periodic(Duration(milliseconds: 50), (_projectilesTimer) {
      if (!_pause) {
        // Stop the timer to save power
        if (projectileList.isEmpty) {
          firstShoot = false;
          _projectilesTimer.cancel();
        }
        for (ProjectileController projectile in projectileList) {
          projectile.travel();
        }
      }
    });
  }

  Widget displayProjectile(List<PlatformController> platformList,
      List<EnemyController> enemyList, BossController boss) {
    removeCollideProjectiles(platformList, enemyList, boss);
    return _view.displayProjectiles(projectileList);
  }

  void removeCollideProjectiles(List<PlatformController> platformList,
      List<EnemyController> enemyList, BossController boss) {
    // Check collisions with platforms + out of screen
    removeCollideProjectilesPlatforms(platformList); // from ShooterMixin
    // Check collisions with enemies
    List<ProjectileController> toRemove = [];
    for (ProjectileController projectile in projectileList) {
      // Collide with an enemy
      for (EnemyController enemy in enemyList) {
        if (projectile.body.collide(enemy.body, pixelWidth, pixelHeight)) {
          aliveProjectile--;
          toRemove.add(projectile);
          enemy.damage(projectile.freezing);
          break;
        }
      }
      // Collide with the boss
      if (!boss.dead) {
        if (projectile.body.collide(boss.body, pixelWidth, pixelHeight)) {
          aliveProjectile--;
          toRemove.add(projectile);
          boss.damage(projectile.freezing);
          if (boss.dead) {
            boss.end();
          }
        }
      }
    }
    projectileList.removeWhere((e) => toRemove.contains(e));
  }

  // Bonuses -------------------------------------------------------------------

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
          maxProjectile = _defaultProjectiles;
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
        maxProjectile = 20;
        break;

      default:
        print("Wrong potion type: " + potion);
        break;
    }
  }

  void damage(double dmg) {
    _model.damage(dmg);
  }

  void heal(double life) {
    _model.heal(life);
  }

  // Accessors -----------------------------------------------------------------

  double get health => _model.life;

  bool get dead => _model.life <= 0.0;

  Body get body => _body;

  // Display -------------------------------------------------------------------

  Widget displayPlayer(bool collision) {
    // After 5sec (10sec) the redPot (bluePot) stops
    // We put that here since this function is called every 50ms
    if (_redPotTimer.elapsedMilliseconds > 5000) {
      _redPotTimer.reset();
      _redPotTimer.stop();
      maxProjectile = _defaultProjectiles;
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
      _bluePotTimer.isRunning,
      collision,
      _hat,
    );
  }

  Widget displayPlayerLife() {
    return _view.displayLife(_lifeWidth, _model.life);
  }
}
