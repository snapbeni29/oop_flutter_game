import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/ObstacleModel.dart';

/// Model class of an enemy
class EnemyModel extends ObstacleModel {
  int maxHealth;
  int _health;
  Body area;
  double _speed = ENEMY_SPEED;
  int type;

  EnemyModel({Body body, this.maxHealth, this.area, this.type})
      : _health = maxHealth,
        super(body: body);

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

  void damage() {
    _health--;
  }

  bool get dead => _health <= 0;

  int get health => _health;
}
