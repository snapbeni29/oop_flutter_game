import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/ObstacleModel.dart';

class CollectableModel extends ObstacleModel{
  String type;
  Body area;

  CollectableModel({Body body, this.type, this.area}) : super(body: body);

  /* The collectable is associated to an area of constant width
      We move this area and adjust the position of the collectable
      in the middle of this area
   */
  void moveLeftArea(double pixelWidth) {
    area.x += SPEED;
    body.x = area.getMiddleWidth(pixelWidth);
  }

  void moveRightArea(double pixelWidth) {
    area.x -= SPEED;
    body.x = area.getMiddleWidth(pixelWidth);
  }
}
