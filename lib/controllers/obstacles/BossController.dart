import 'dart:async';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/PlayerController.dart';
import 'package:corona_bot/controllers/ShooterMixin.dart';
import 'package:corona_bot/controllers/obstacles/EnemyController.dart';
import 'package:corona_bot/controllers/obstacles/PlatformController.dart';
import 'package:corona_bot/controllers/obstacles/ProjectileController.dart';
import 'package:flutter/material.dart';

/// A boss is an enemy that can shoot projectiles
class BossController extends EnemyController with ShooterMixin {
  // Timers
  Timer _projectilesTimer;
  Timer _checkPlayerTimer;
  Stopwatch _shootInterval = Stopwatch();
  bool _pause = false;
  PlayerController _player;

  BossController(double pw, double ph, Body body, Body area,
      PlayerController player, int type)
      : super(body, BOSS_HEALTH, area, type: type) {
    pixelWidth = pw;
    pixelHeight = ph;
    _player = player;
  }

  // Deal with timers ----------------------------------------------------------

  /// Stop all timers
  void end() {
    if (_projectilesTimer != null) _projectilesTimer.cancel();
    if (_checkPlayerTimer != null) _checkPlayerTimer.cancel();
  }

  set setPause(bool value) => _pause = value;

  // Movement related functions ------------------------------------------------

  void moveRight() {
    model.moveRight();
    for (ProjectileController projectile in projectileList) {
      projectile.moveRight();
    }
  }

  void moveLeft() {
    model.moveLeft();
    for (ProjectileController projectile in projectileList) {
      projectile.moveLeft();
    }
  }

  // Shoot related functions ---------------------------------------------------

  bool get isShooting =>
      _projectilesTimer != null ? _projectilesTimer.isActive : false;

  void startProjectile() {
    _shootInterval.start();
    _projectilesTimer =
        Timer.periodic(Duration(milliseconds: 50), (_projectilesTimer) {
      if (_canShoot()) {
        _shootInterval.reset();
        firstShoot = true;
        shootMixin(
          _player.x < model.body.x
              ? Direction.STILL_LEFT
              : Direction.STILL_RIGHT,
          false,
          new Body(
            x: _player.x < model.body.x
                ? model.body.getLeftBoundary(pixelWidth)
                : model.body.getRightBoundary(pixelWidth),
            y: model.body.getMiddleHeight(pixelHeight),
            width: model.body.width / 8.0,
            height: model.body.height / 8.0,
          ),
          yAngle: computeYDirection(),
        );
      }
      if (!_pause) {
        for (ProjectileController projectile in projectileList) {
          projectile.travel();
        }
      }
    });
  }

  /// When the boss shoots, it looks at the player location and shoots
  /// toward this position.
  double computeYDirection() {
    double yM = body.getMiddleHeight(pixelHeight);
    double yP = _player.body.getMiddleHeight(pixelHeight);
    double xM = body.getMiddleWidth(pixelWidth);
    double xP = _player.body.getMiddleWidth(pixelWidth);
    double slope = -(yM - yP) / ((xM - xP).abs());

    return slope * PROJECTILE_SPEED;
  }

  /// The boss will start shooting when the player comes in range.
  void enableShooting() {
    _checkPlayerTimer =
        Timer.periodic(Duration(milliseconds: 500), (_checkPlayerTimer) {
      if (model.body.x < _player.body.x + 2) {
        if (_projectilesTimer == null || !_projectilesTimer.isActive) {
          startProjectile();
          _checkPlayerTimer.cancel();
        }
      }
    });
  }

  bool _canShoot() => _shootInterval.elapsedMilliseconds >= 3000;

  // Display -------------------------------------------------------------------

  Widget displayProjectile(
      List<PlatformController> platformList, PlayerController player) {
    if (projectileList.isNotEmpty) {
      removeCollideProjectiles(platformList, player);
      return view.displayProjectiles(projectileList);
    }
    return Container();
  }

  void removeCollideProjectiles(
      List<PlatformController> platformList, PlayerController player) {
    // Check collisions with platforms + out of screen
    removeCollideProjectilesPlatforms(platformList); // from ShooterMixin
    // Check collisions with the player
    List<ProjectileController> toRemove = <ProjectileController>[];
    for (ProjectileController projectile in projectileList) {
      // Collide with the player
      if (projectile.body.collide(player.body, pixelWidth, pixelHeight)) {
        aliveProjectile--;
        toRemove.add(projectile);
        player.damage(0.1);
      }
    }
    if (toRemove.isNotEmpty) {
      projectileList.removeWhere((e) => toRemove.contains(e));
    }
  }
}
