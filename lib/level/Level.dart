import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/level/Enemy.dart';
import 'package:flutter_app_mario/level/Layout.dart';
import 'package:flutter_app_mario/level/Platform.dart';
import 'package:flutter_app_mario/player/Player.dart';
import 'package:flutter_app_mario/hit_box/Body.dart';

class Level extends ChangeNotifier {
  // Timers
  Timer _enemyTimer;
  Timer _runLeftTimer;
  Timer _runRightTimer;

  // Pause variables to momentarily stop the game
  // Initially it's false and when pushing pause button it is set to true
  bool _pause = false;

  // Value of the score reached by the player, evolve during the level
  double score = 0;

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

    // Get the layout of the level
    Layout layout = new Layout();
    _platformList = layout.createPlatforms(context);
    _enemyList = layout.createEnemies(context);

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

  /* Stop all timers.
    Called when we exit the game.
   */
  void end(BuildContext context) {
    if (_enemyTimer != null) _enemyTimer.cancel();
    if (_runRightTimer != null) _runRightTimer.cancel();
    if (_runLeftTimer != null) _runLeftTimer.cancel();

    _player.end();
    // First pop to get out of the alert dialog
    Navigator.of(context).pop();
    // Second pop to go to the Home Page
    Navigator.of(context).pop();
  }

  /* Pause the game
   */
  pause(BuildContext context) {
    _pause = true;
    _player.pause = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Center(child: Text("Menu")),
          backgroundColor: Colors.blueAccent,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                elevation: 2.0,
                onPressed: (){
                  end(context);
                },
                child: Text("Go to Level Menu"),
                color: Colors.greenAccent,
              ),
              RaisedButton(
                elevation: 2.0,
                onPressed: (){
                  restart();
                  Navigator.of(context).pop();
                },
                child: Text("Resume the Level"),
                color: Colors.greenAccent
              ),
            ],
          ),
          elevation: 10.0,
        );
      },
    );
  }

  /* restart the game
   */
  void restart() {
    _player.pause = false;
    _pause = false;
  }

  // Enemy interactions -------------------------------------------------------

  void startMovingEnemies() {
    _enemyTimer = Timer.periodic(Duration(milliseconds: 50), (_enemyTimer) {
      if(!_pause) {
        if (_enemyList.isEmpty) {
          _enemyTimer.cancel();
        }
        if (_player.dead) {
          _enemyTimer.cancel();
          // TODO: Game over
        }

        List<Enemy> toRemove = [];
        for (Enemy enemy in _enemyList) {
          // If enemy is not dead
          enemy.moveOnce(_pixelWidth);
          // Check if an enemy deals damage
          if (enemy.body.collide(_player.body, _pixelWidth, _pixelHeight)) {
            _player.hurt(0.01);
          }
          // Remove the dead enemies
          if (enemy.dead){
            toRemove.add(enemy);
            score += 100;
          }
        }
        _enemyList.removeWhere((e) => toRemove.contains(e));

        notifyListeners();
      }
    });
  }

  // Player movement ----------------------------------------------------------

  void moveLeft() {
    if (_player.direction == 'right' && _midRun) return;

    _midRun = true;
    _player.moveLeft();

    _runLeftTimer = Timer.periodic(Duration(milliseconds: 50), (_runLeftTimer) {
      if (_midRun) {
        // Collision with a platform
        bool collision = false;
        for (Platform pt in _platformList) {
          if (_player.body.collideHorizontally(
              pt.body, _player.direction, _speed, _pixelWidth, _pixelHeight)) {
            stopMoveLeft();
            _runLeftTimer.cancel();
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
          // Update player sprite
          _player.runPos = (_player.runPos + 1) % 8;
          // Update enemies
          for (Enemy enemy in _enemyList) {
            enemy.moveLeft(_speed);
          }
          notifyListeners();
        }
      } else {
        _runLeftTimer.cancel();
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

    _runRightTimer =
        Timer.periodic(Duration(milliseconds: 50), (_runRightTimer) {
      if (_midRun) {
        // Collision with a platform
        bool collision = false;
        for (Platform pt in _platformList) {
          if (_player.body.collideHorizontally(
              pt.body, _player.direction, _speed, _pixelWidth, _pixelHeight)) {
            //debugPrint(pt.height.toString());
            stopMoveRight();
            _runRightTimer.cancel();
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
          // Update player sprite
          _player.runPos = (_player.runPos + 1) % 8;
          // Update enemies
          for (Enemy enemy in _enemyList) {
            enemy.moveRight(_speed);
          }
          notifyListeners();
        }
      } else {
        _runRightTimer.cancel();
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

  void shoot(_){
    _player.shoot();
  }

  void fall() {
    _player.fall(_platformList);
  }

  // Return true if the player is walking off a platform
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

  Player get player => _player;
}
