import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/ObstacleModel.dart';

class CollectableModel extends ObstacleModel{
  String type;
  Body area;

  CollectableModel({Body body, this.type, this.area}) : super(body: body);

  void moveLeftArea(double pixelWidth) {
    area.x += SPEED;
    body.x = area.getMiddle(pixelWidth);
  }

  void moveRightArea(double pixelWidth) {
    area.x -= SPEED;
    body.x = area.getMiddle(pixelWidth);
  }
}
