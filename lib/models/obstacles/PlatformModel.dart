import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/ObstacleModel.dart';
import 'package:corona_bot/models/obstacles/DamageMixin.dart';

/// Model class of a Platform
class PlatformModel extends ObstacleModel with DamageMixin {
  PlatformModel({Body body}) : super(body: body);

  PlatformModel.breakable({Body body, int mHealth}): super(body: body) {
    maxHealth = mHealth;
    health = maxHealth;
  }
}
