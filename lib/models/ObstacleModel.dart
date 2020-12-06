import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';

/// Model class of an Obstacle
class ObstacleModel {
  Body body;

  ObstacleModel({this.body});

  /*
  * An obstacle is part of the environment. The functions moveLeft and
  * moveRight denotes the action to do when the player is moving respectively
  * to the left or the the right. Thus when player is moving to the right the
  * environment should move to the left and vice versa
  */

  /// If player moves to the left, we move the obstacle to the right
  void moveLeft() {
    body.x += SPEED;
  }

  /// If player moves to the right, we move the obstacle to the left
  void moveRight() {
    body.x -= SPEED;
  }
}
