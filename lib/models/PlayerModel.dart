import 'dart:math';

import 'package:corona_bot/constants.dart';

class PlayerModel {
  double _life = 1.0;

  int _runPos = 0;

  Direction _vertical = Direction.STILL;
  Direction _horizontal = Direction.STILL_RIGHT;

  // Life related functions ----------------------------------------------------

  void damage(double dmg) {
    if (_life > 0.0) _life = max(_life - dmg, 0.0);
  }

  void heal(double life) {
    _life = min(_life + life, 1.0);
  }

  double get life => _life;

  // Movement related functions ------------------------------------------------

  void moveLeft() {
    _horizontal = Direction.LEFT;
    _runPos = (_runPos + 1) % 8;
  }

  void moveRight() {
    _horizontal = Direction.RIGHT;
    _runPos = (_runPos + 1) % 8;
  }

  void stopRun() {
    _horizontal = _horizontal == Direction.RIGHT
        ? Direction.STILL_RIGHT
        : Direction.STILL_LEFT;
  }

  set jump(Direction direction) => _vertical = direction;

  Direction get horizontal => _horizontal;

  Direction get vertical => _vertical;

  int get sprite => _runPos;
}
