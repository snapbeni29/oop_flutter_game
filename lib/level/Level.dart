import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/level/Enemy.dart';
import 'package:flutter_app_mario/level/Layout.dart';
import 'package:flutter_app_mario/level/Platform.dart';
import 'package:flutter_app_mario/player/Player.dart';
import 'package:flutter_app_mario/hit_box/Body.dart';

class Level extends ChangeNotifier {
  //double _posX = 0.7;
  //double _posY = 0.5;

  // Speed of movement
  double _speed = 0.025;
  bool _midRun = false;

  // Reference to the player
  Player _player;

  // Value that depend on the device
  double _pixelWidth;
  double _pixelHeight;
  double _lifeWidth;

  // Lists of platforms and enemies that player may interact with
  List<Platform> _platformList;
  List<Enemy> _enemyList;

  Level(Player player, BuildContext context) {
    _player = player;

    _platformList = Layout().createPlatforms(context);
    _enemyList = Layout().createEnemies(context);

    _pixelWidth = 2.0 / MediaQuery.of(context).size.width;
    _pixelHeight = 2.0 / (MediaQuery.of(context).size.height * 5.0 / 7.0);

    _lifeWidth = MediaQuery.of(context).size.width / 3.0;

    startMovingEnemies();
  }

  Widget displayLevel() {
    List<Widget> widgetList = new List();

    // Platforms
    for (Platform pf in _platformList) {
      widgetList.add(pf.displayPlatform());
    }

    // Player
    widgetList.add(
      AnimatedContainer(
        alignment: Alignment(_player.posX, _player.posY),
        duration: Duration(milliseconds: 0),
        child: _player.displayPlayer(),
      ),
    );

    // Life bar
    widgetList.add(
      AnimatedContainer(
        alignment: Alignment(0.0, -0.9),
        duration: Duration(milliseconds: 0),
        child: _player.displayLife(_lifeWidth),
      ),
    );

    // Projectiles
    widgetList.add(
      _player.displayProjectile(_platformList, _enemyList),
    );

    // Enemies
    for (Enemy enemy in _enemyList) {
      widgetList.add(
        AnimatedContainer(
          alignment: Alignment(enemy.body.x, enemy.body.y),
          duration: Duration(milliseconds: 0),
          child: enemy.displayEnemy(),
        ),
      );
      // With their health bar
      widgetList.add(
        AnimatedContainer(
          alignment: Alignment(enemy.body.x,
              getTopBoundary(enemy.body.y, enemy.body.height, _pixelHeight)),
          duration: Duration(milliseconds: 0),
          child: enemy.displayHealthBar(),
        ),
      );
    }

    return Stack(
      children: widgetList,
    );
  }

  // Enemy interactions -------------------------------------------------------

  /* TODO: Bug solving
      I remove a dead enemy from the list.
      It is correctly removed for the display function,
      but not in this timer.
      You can see in the log that the player's health is decreasing
      like the enemy was not dead.
      It looks like there are two different players...
   */
  void startMovingEnemies() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(_enemyList.isEmpty)
        timer.cancel();

      if (_player.dead) {
        print("Game over");
        timer.cancel();
      }

      List<Enemy> toRemove = [];
      for (Enemy enemy in _enemyList) {
        // If enemy is not dead
          enemy.moveOnce(_player);
          // Check if an enemy deals damage
          if (enemy.body.collide(_player.body, _pixelWidth, _pixelHeight)) {
            print(enemy.name);
            _player.hurt(0.01);
          }
          if(enemy.dead)
            toRemove.add(enemy);
      }
      _enemyList.removeWhere( (e) => toRemove.contains(e));

      notifyListeners();
    });
  }

  // Player movement ----------------------------------------------------------

  void moveLeft() {
    if (_player.direction == 'right' && _midRun) return;

    _midRun = true;
    _player.moveLeft();

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_midRun) {
        // Collision with a platform
        bool collision = false;
        for (Platform pt in _platformList) {
          if (_player.body.collideHorizontally(
              pt.body, _player.direction, _speed, _pixelWidth, _pixelHeight)) {
            stopMoveLeft();
            timer.cancel();
            notifyListeners();
            collision = true;
            break;
          }
        }

        // Walk off edge
        if (!collision) {
          // Update platforms
          for (Platform pt in _platformList) {
            pt.moveLeft(_speed);
            if (isFalling(pt, _player.direction) && !_player.midJump) {
              _player.fall(_platformList);
            }
          }
          // Update enemies
          for (Enemy enemy in _enemyList) {
            enemy.moveLeft(_speed);
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
          if (_player.body.collideHorizontally(
              pt.body, _player.direction, _speed, _pixelWidth, _pixelHeight)) {
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
          // Update platforms
          for (Platform pt in _platformList) {
            pt.moveRight(_speed);
            if (isFalling(pt, _player.direction) && !_player.midJump) {
              _player.fall(_platformList);
            }
          }
          // Update enemies
          for (Enemy enemy in _enemyList) {
            enemy.moveRight(_speed);
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
