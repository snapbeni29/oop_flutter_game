import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/ObstacleModel.dart';
import 'package:corona_bot/models/obstacles/DamageMixin.dart';

/// Model class of an enemy
class EnemyModel extends ObstacleModel with DamageMixin {
  Body area;
  double _speed = ENEMY_SPEED;
  int type;

  EnemyModel({Body body, int mHealth, this.area, this.type})
      : super(body: body) {
    maxHealth = mHealth;
    health = maxHealth;
  }

  /// An enemy moves on its assigned platform
  void moveOnce(double pW) {
    if ((_speed > 0 &&
            body.getRightBoundary(pW) > area.getRightBoundary(pW)) ||
        (_speed <= 0 &&
            body.getLeftBoundary(pW) < area.getLeftBoundary(pW)))
      _speed = -_speed;

    body.x += _speed;
  }

  @override
  void moveLeft() {
    body.x += SPEED;
    area.x += SPEED;
  }

  @override
  void moveRight() {
    body.x -= SPEED;
    area.x -= SPEED;
  }
}
