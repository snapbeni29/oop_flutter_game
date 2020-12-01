import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/ObstacleModel.dart';


class ProjectileModel extends ObstacleModel {
  Direction direction;
  double _speed = PROJECTILE_SPEED;
  bool blue;
  double yAngle = 0;

  ProjectileModel({Body body, this.direction, this.blue, this.yAngle}) : super(body: body);

  void travel() {
    body.y -= yAngle;
    if (direction == Direction.RIGHT || direction == Direction.STILL_RIGHT)
      body.x += _speed;
    else if (direction == Direction.LEFT || direction == Direction.STILL_LEFT)
      body.x -= _speed;
  }
}
