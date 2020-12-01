/* Define constants and a structure to easily create a layout
    The BodyConstants structure contains all elements required to
    define an obstacle (Boss, Enemy, Platform, Collectable).
 */

class BodyConstants {
  final double x, y, w, h;
  final String collectable;

  const BodyConstants({this.x, this.y, this.w, this.h, this.collectable});
}

// All platforms have the same width, such that they move on the screen
// at the same speed.
const double platformWidth = 8;
const double spacing = 2/platformWidth;

const double areaHeight = 8;

const double collectableWidth = 40;
const double collectableHeight = 10;

const double bossHeight = 2;
const double bossWidth = 4;
