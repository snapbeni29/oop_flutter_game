import 'dart:math';

import 'package:corona_bot/constants.dart';
import 'package:flutter/cupertino.dart';
/// Model of the class Player
class PlayerModel {
  double _life = 1.0;

  int _runPos = 0;
  // Look at the file constants to see all the directions possible
  Direction _vertical = Direction.STILL;
  Direction _horizontal = Direction.STILL_RIGHT;

  // Life related functions ----------------------------------------------------

  /// If player not dead, decreases the [_life] of the player of [dmg]
  void damage(double dmg) {
    if (_life > 0.0) _life = max(_life - dmg, 0.0);
  }

  /// Increases the [_life] of the player of [life]
  void heal(double life) {
    _life = min(_life + life, 1.0);
  }

  double get life => _life;

  // Movement related functions ------------------------------------------------

  /*
   * It's important to note that the player doesn't move, it's the environment
   * that move. So the moving functions of the player are only updating its
   * direction and its position to display to right image and create running
   * animation.
   */

  /// Updates the [_horizontal] direction of the player to Left and updates its
  /// [_runPos].
  void moveLeft() {
    _horizontal = Direction.LEFT;
    _runPos = (_runPos + 1) % 8;
  }

  /// Updates the [_horizontal] direction of the player to Right and updates its
  /// [_runPos].
  void moveRight() {
    _horizontal = Direction.RIGHT;
    _runPos = (_runPos + 1) % 8;
  }

  /// Updates the [_horizontal] direction of the player to still Right or Left
  /// depending on where he's looking.
  void stopRun() {
    _horizontal = _horizontal == Direction.RIGHT
        ? Direction.STILL_RIGHT
        : Direction.STILL_LEFT;
  }

  /// Update the [_vertical] direction of the player
  set jump(Direction direction) => _vertical = direction;

  Direction get horizontal => _horizontal;

  Direction get vertical => _vertical;

  int get sprite => _runPos;
}
