import 'package:corona_bot/constants.dart';

/*
  A Body is a useful class that defines a size (width & height) and a position
  (coordinates x & y). Two bodies can collide in a specific direction
  (collideHorizontally & collideVertically), or simply overlap (collide).
  A set of function are also defined to get the coordinates of some parts
  of the body (left, right, top, bottom boundary, middle position...).
 */
class Body {
  // Defines the size of the body
  double width, height;

  // Defines the center of the body
  double x, y;

  Body({this.width, this.height, this.x, this.y});

  // Return true if both bodies overlap
  bool collide(Body other, double pixelWidth, double pixelHeight) {
    if (this.getRightBoundary(pixelWidth) < other.getLeftBoundary(pixelWidth) ||
        this.getLeftBoundary(pixelWidth) > other.getRightBoundary(pixelWidth) ||
        this.getTopBoundary(pixelHeight) >
            other.getBottomBoundary(pixelHeight) ||
        this.getBottomBoundary(pixelHeight) < other.getTopBoundary(pixelHeight))
      return false;

    return true;
  }

  /*
    'this' goes in 'direction'
    return true if this collides with other horizontally
   */
  bool collideHorizontally(
      Body other, Direction direction, double speed, double pW, double pH) {
    if (direction == Direction.RIGHT) {
      if (this.getRightBoundary(pW) + speed > other.getLeftBoundary(pW) &&
          this.getLeftBoundary(pW) < other.getRightBoundary(pW)) {
        // No collision if player under the block
        if (this.getTopBoundary(pH) > other.getBottomBoundary(pH)) return false;

        // No collision if player above block
        if (this.getBottomBoundary(pH) < other.getTopBoundary(pH) + 0.02)
          return false;

        return true;
      }
    } else if (direction == Direction.LEFT) {
      if (this.getRightBoundary(pW) > other.getLeftBoundary(pW) &&
          this.getLeftBoundary(pW) - speed < other.getRightBoundary(pW)) {
        // No collision if player under the block
        if (this.getTopBoundary(pH) > other.getBottomBoundary(pH)) return false;

        // No collision if player above block
        if (this.getBottomBoundary(pH) < other.getTopBoundary(pH) + 0.02)
          return false;

        return true;
      }
    }
    return false;
  }

  /*
    this goes in direction
    return true if this collides with other vertically
   */
  bool collideVertically(
      Body other, Direction direction, double speed, double pW, double pH) {
    if (direction == Direction.UP) {
      if (this.getBottomBoundary(pH) - 0.02 > other.getTopBoundary(pH) &&
          this.getTopBoundary(pH) - speed < other.getBottomBoundary(pH)) {
        // No collision if left of other
        if (this.getRightBoundary(pW) < other.getLeftBoundary(pW)) return false;

        // No collision if right of other
        if (this.getLeftBoundary(pW) > other.getRightBoundary(pW)) return false;

        return true;
      }
    } else if (direction == Direction.DOWN) {
      if (this.getBottomBoundary(pH) + speed > other.getTopBoundary(pH) &&
          this.getTopBoundary(pH) < other.getBottomBoundary(pH)) {
        // No collision if left of other
        if (this.getRightBoundary(pW) < other.getLeftBoundary(pW)) return false;

        // No collision if right of other
        if (this.getLeftBoundary(pW) > other.getRightBoundary(pW)) return false;

        return true;
      }
    }
    return false;
  }

  /*
  Helper functions
  -> dynamically gets the boundaries of a body on the screen,
     based on a coordinate and a length
 */

  double getBottomBoundary(double pixelHeight) {
    double bottomPart = 0.5 - y / 2;
    return y + pixelHeight * height * bottomPart;
  }

  double getTopBoundary(double pixelHeight) {
    double topPart = 0.5 + y / 2;
    return y - pixelHeight * height * topPart;
  }

  double getRightBoundary(double pixelWidth) {
    double rightPart = 0.5 - x / 2;
    return x + pixelWidth * width * rightPart;
  }

  double getLeftBoundary(double pixelWidth) {
    double leftPart = 0.5 + x / 2;
    return x - pixelWidth * width * leftPart;
  }

  double getMiddleWidth(double pixelWidth) {
    double leftPart = 0.5 + x / 2;
    double rightPart = 0.5 - x / 2;
    if (x == 0) {
      return x;
    } else if (x < 0) {
      return x + pixelWidth * (0.5 - leftPart) * width;
    } else {
      return x - pixelWidth * (0.5 - rightPart) * width;
    }
  }

  double getMiddleHeight(double pixelHeight) {
    double bottomPart = 0.5 - y / 2;
    double topPart = 0.5 + y / 2;
    if (y == 0) {
      return y;
    } else if (y < 0) {
      return y + pixelHeight * (0.5 - topPart) * width;
    } else {
      return y - pixelHeight * (0.5 - bottomPart) * height;
    }
  }
}
