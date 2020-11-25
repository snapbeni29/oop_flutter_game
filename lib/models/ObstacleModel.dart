import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';

class ObstacleModel {
  Body body;

  ObstacleModel({this.body});

  void moveLeft() {
    body.x += SPEED;
  }

  void moveRight() {
    body.x -= SPEED;
  }
}
