class BodyConstants {
  final double x, y, w, h;
  final String collectable;

  const BodyConstants({this.x, this.y, this.w, this.h, this.collectable});
}

const double platformWidth = 8;
const double spacing = 2/platformWidth;

const double areaHeight = 8;

const double collectableWidth = 40;
const double collectableHeight = 10;
