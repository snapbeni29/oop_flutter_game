import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';

/// Model class of an Obstacle
class ObstacleModel {
  Body body;

  ObstacleModel({this.body});

  /*
  * An obstacle is part of the environment. The functions MoveLeft and
  * MoveRight denotes the action to do when the PLAYER is moving respectively
  * to the Left or the the Right. Thus when Player is moving to the right the
  * environment should move to the Left and vice versa
   */

  /// If Player move to the Left, we move the obstacle to the right
  void moveLeft() {
    body.x += SPEED;
  }

  /// If Player move to the right, we move the obstacle to the left
  void moveRight() {
    body.x -= SPEED;
  }
}
