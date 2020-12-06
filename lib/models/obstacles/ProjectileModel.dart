import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/ObstacleModel.dart';

/// Model class of a Projectile
///
/// A Projectile extends an Obstacle and thus inherits the function moveRight
/// and moveLeft
class ProjectileModel extends ObstacleModel {
  Direction direction;
  double _speed = PROJECTILE_SPEED;
  bool blue;
  double yAngle = 0;

  ProjectileModel({Body body, this.direction, this.blue, this.yAngle})
      : super(body: body);

  /// Moves the projectile toward [direction] at [_speed] for the X axis.
  /// For the Y axis, if an [yAngle] was provided at the creation of the
  /// projectile, the projectile moves of [yAngle].
  void travel() {
    body.y += yAngle;
    if (direction == Direction.RIGHT || direction == Direction.STILL_RIGHT)
      body.x += _speed;
    else if (direction == Direction.LEFT || direction == Direction.STILL_LEFT)
      body.x -= _speed;
  }
}
