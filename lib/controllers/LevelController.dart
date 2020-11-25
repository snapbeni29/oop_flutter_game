import 'dart:async';
import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/PlayerController.dart';
import 'package:corona_bot/controllers/obstacles/CollectableController.dart';
import 'package:corona_bot/controllers/obstacles/EnemyController.dart';
import 'package:corona_bot/controllers/obstacles/PlatformController.dart';
import 'package:corona_bot/layouts/Layout.dart';
import 'package:corona_bot/models/LevelModel.dart';
import 'package:corona_bot/views/LevelView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelController extends ChangeNotifier {
  LevelModel _model;
  LevelView _view;

  int _levelNumber;
  PlayerController _player;

  int coins = 0;

  // Timers
  Timer _enemyTimer;
  Timer _runLeftTimer;
  Timer _runRightTimer;

  // Pause variable to momentarily stop the game
  // Initially false, set to true when pushing pause button
  bool _pause = false;

  bool _midRun = false;

  // Value that depend on the device
  double _pixelWidth;
  double _pixelHeight;

  // Lists of obstacles that player may interact with
  List<PlatformController> _platformList;
  List<EnemyController> _enemyList;
  List<CollectableController> _collectableList;

  LevelController(
      PlayerController player, BuildContext context, int levelNumber) {
    _model = new LevelModel();
    _view = new LevelView();

    _levelNumber = levelNumber;
    _player = player;

    _pixelWidth = 2.0 / MediaQuery.of(context).size.width;
    _pixelHeight = 2.0 / (MediaQuery.of(context).size.height * 5.0 / 7.0);

    Layout layout = new Layout(context, levelNumber: levelNumber);
    _platformList = layout.createPlatforms();
    _enemyList = layout.createEnemies();
    _collectableList = layout.createCollectables();

    startMovingEnemies(context);
  }

  Widget displayLevel() {
    // Remove the collectables
    List<CollectableController> toRemove = <CollectableController>[];
    for (CollectableController collectable in _collectableList) {
      if (collectable.body.collide(_player.body, _pixelWidth, _pixelHeight)) {
        if (collectable.type != END_FLAG) {
          if (collectable.type == COIN) {
            coins++;
          } else {
            _player.drinkPotion(collectable.type);
          }
          toRemove.add(collectable);
        }
      }
    }
    _collectableList.removeWhere((e) => toRemove.contains(e));

    return _view.displayLevel(
        _player, _platformList, _enemyList, _collectableList, _pixelHeight);
  }

  // Game actions

  void restart(bool fullLife) {
    if (fullLife) {
      _model.usePoints(100);
      _model.resetTimer();
      _player.heal(1.0);
    }
    _model.startTimer();
    _player.pause = false;
    _pause = false;
  }

  pause(BuildContext context) {
    alertDialog(context, true, false, "Menu", "Resume");
  }

  gameWon(BuildContext context) {
    // Add time left to the score
    _model.winPoints(_model.timeLeft);
    // Add life left to the score
    _model.winPoints(_player.health * 100);
    alertDialog(context, false, true, "Well played!",
        "Coins collected: " + coins.toString());
  }

  timeOver(BuildContext context) {
    alertDialog(
        context, false, false, "Time Over!", "Use 100 points to buy more time");
  }

  gameOver(BuildContext context) {
    alertDialog(context, false, false, "Game Over!",
        "Use 100 points to buy an extra life");
  }

  alertDialog(BuildContext context, bool buttonGreen, bool buttonGrey,
      String title, String buttonText) {
    _pause = true;
    _player.pause = true;
    _model.stopTimer();
    bool finalButtonGreen = buttonGreen || (!buttonGrey && _model.score >= 100);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Center(child: Text(title)),
          backgroundColor: Colors.blueAccent,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text("Score: " + _model.score.toStringAsFixed(0)),
              ),
              RaisedButton(
                elevation: 2.0,
                onPressed: () {
                  if (finalButtonGreen) {
                    // full life if not in the case "pause"
                    restart(!buttonGreen);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(buttonText),
                color: finalButtonGreen ? BUTTON_COLOR : BUTTON_STUCK,
              ),
              RaisedButton(
                elevation: 2.0,
                onPressed: () async {
                  // We only save the score if the game was won
                  if (buttonGrey) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int curCoins = prefs.getInt('coins');
                    List<String> curScoreLevel =
                        prefs.getStringList("scoreLevel");

                    curCoins = curCoins == null ? coins : curCoins + coins;
                    prefs.setInt('coins', curCoins);

                    if (curScoreLevel == null) {
                      curScoreLevel = <String>[];
                      curScoreLevel.add("$_levelNumber:${_model.score}");
                    } else {
                      int maxLvl = curScoreLevel.length;
                      // level is the last in the list
                      if (_levelNumber <= maxLvl) {
                        if (_model.score >
                            double.parse(
                                curScoreLevel[_levelNumber - 1].split(":")[1]))
                          curScoreLevel[_levelNumber - 1] =
                              "$_levelNumber:${_model.score}";
                      } else
                        curScoreLevel.add("$_levelNumber:${_model.score}");
                    }
                    prefs.setStringList('scoreLevel', curScoreLevel);
                  }
                  end(context);
                },
                child: Text("Go to Level Menu"),
                color: BUTTON_COLOR,
              ),
            ],
          ),
          elevation: 10.0,
        );
      },
    );
  }

  /* Stop all timers.
    Called when we exit the game.
   */
  void end(BuildContext context) {
    if (_enemyTimer != null) _enemyTimer.cancel();
    if (_runRightTimer != null) _runRightTimer.cancel();
    if (_runLeftTimer != null) _runLeftTimer.cancel();

    _model.stopTimer();
    _player.end();

    // First pop to get out of the alert dialog
    Navigator.of(context).pop();
    // Second pop to go to the Home Page
    Navigator.of(context).pop();

    // Create the new HomePage with the new set preferences
    Navigator.of(context).pop();
    Navigator.pushNamed((context), '/');
  }

  // Player actions ------------------------------------------------------------

  void shoot(_) {
    _player.shoot();
  }

  void jump(double velocity) {
    _player.jump(velocity, _platformList);
  }

  // Timer for the entire level ------------------------------------------------

  void startMovingEnemies(BuildContext context) {
    _enemyTimer = Timer.periodic(Duration(milliseconds: 50), (_enemyTimer) {
      if (!_pause) {
        // The player can only die if there are enemies
        if (_player.dead) {
          gameOver(context);
        }
        // The game ends if the timer is over
        if (_model.timeOver) {
          timeOver(context);
        }
        // The game ends with a win if we reach the flag (END_FLAG)
        for (CollectableController collectable in _collectableList) {
          if (collectable.type == END_FLAG &&
              collectable.body
                  .collide(_player.body, _pixelWidth, _pixelHeight)) {
            gameWon(context);
          }
        }

        // Enemy interactions
        if (_enemyList.isNotEmpty) {
          List<EnemyController> toRemove = [];
          for (EnemyController enemy in _enemyList) {
            // If enemy is not dead
            enemy.moveOnce(_pixelWidth);
            // Check if an enemy deals damage
            if (enemy.body.collide(_player.body, _pixelWidth, _pixelHeight)) {
              _player.damage(0.01);
            }
            // Remove the dead enemies
            if (enemy.dead) {
              toRemove.add(enemy);
              _model.winPoints(100);
            }
          }
          _enemyList.removeWhere((e) => toRemove.contains(e));
        }

        notifyListeners();
      }
    });
  }

  // Movement related functions ------------------------------------------------

  void moveRight() {
    if (_player.direction == Direction.LEFT && _midRun) return;

    _midRun = true;
    _player.moveRight();

    _runRightTimer =
        Timer.periodic(Duration(milliseconds: 50), (_runRightTimer) {
      if (!_pause) {
        if (_midRun) {
          // Collision with a platform
          bool collision = false;
          for (PlatformController pt in _platformList) {
            if (_player.body.collideHorizontally(
                pt.body, _player.direction, SPEED, _pixelWidth, _pixelHeight)) {
              stopMoveRight();
              _runRightTimer.cancel();
              notifyListeners();
              collision = true;
              break;
            }
          }

          if (!collision) {
            // Update platforms
            for (PlatformController pt in _platformList) {
              pt.moveRight();
              // Walk off edge
              if (_player.vertical == Direction.STILL &&
                  _player.isFallingOfPlatform(pt)) {
                _player.fall(_platformList);
              }
            }
            // Update enemies
            for (EnemyController enemy in _enemyList) {
              enemy.moveRight();
            }
            // Update collectables
            for (CollectableController collectable in _collectableList) {
              collectable.moveRight(_pixelWidth);
            }
            // Update player and projectiles
            _player.moveRight();
            notifyListeners();
          }
        } else {
          _runRightTimer.cancel();
          notifyListeners();
        }
      }
    });
  }

  void stopMoveRight() {
    if (_player.direction == Direction.RIGHT) {
      _midRun = false;
      _player.stopRun();
    }
  }

  void moveLeft() {
    if (_player.direction == Direction.RIGHT && _midRun) return;

    _midRun = true;
    _player.moveLeft();

    _runLeftTimer = Timer.periodic(Duration(milliseconds: 50), (_runLeftTimer) {
      if (!_pause) {
        if (_midRun) {
          // Collision with a platform
          bool collision = false;
          for (PlatformController pt in _platformList) {
            if (_player.body.collideHorizontally(
                pt.body, _player.direction, SPEED, _pixelWidth, _pixelHeight)) {
              stopMoveLeft();
              _runLeftTimer.cancel();
              notifyListeners();
              collision = true;
              break;
            }
          }

          if (!collision) {
            // Update platforms
            for (PlatformController pt in _platformList) {
              pt.moveLeft();
              // Walk off edge
              if (_player.vertical == Direction.STILL &&
                  _player.isFallingOfPlatform(pt)) {
                _player.fall(_platformList);
              }
            }
            // Update enemies
            for (EnemyController enemy in _enemyList) {
              enemy.moveLeft();
            }
            // Update collectables
            for (CollectableController collectable in _collectableList) {
              collectable.moveLeft(_pixelWidth);
            }
            // Update player and projectiles
            _player.moveLeft();
            notifyListeners();
          }
        } else {
          _runLeftTimer.cancel();
          notifyListeners();
        }
      }
    });
  }

  void stopMoveLeft() {
    if (_player.direction == Direction.LEFT) {
      _midRun = false;
      _player.stopRun();
    }
  }

  // Getters -------------------------------------------------------------------

  PlayerController get player => _player;

  double get score => _model.score;

  String get time => _model.time;
}
