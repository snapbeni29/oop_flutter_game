class Body {
  double width, height;

  // Defines the center of the body
  double x, y;

  Body({this.width, this.height, this.x, this.y});

  /*
    this goes in direction
    return true if this collides with other horizontally
   */
  bool collideHorizontally(Body other, double pW, double pH) {
    print(getRightBoundary(x, width, pW));
    print(getLeftBoundary(other.x, other.width, pW));

    if (getRightBoundary(x, width, pW) >=
            getLeftBoundary(other.x, other.width, pW) &&
        getLeftBoundary(x, width, pW) <=
            getRightBoundary(other.x, other.width, pW)) {
      // No collision if top of block is under the player
      if (getTopBoundary(y, height, pH) >
          getBottomBoundary(other.y, other.height, pH)) return false;

      // No collision if bottom of block is above the head of the character
      if (getBottomBoundary(y, height, pH) <
          getTopBoundary(other.y, other.height, pH)) return false;

      return true;
    }
    return false;
  }

  bool collideVertically(Body other, double pW, double pH) {
    if (getBottomBoundary(y, height, pH) >=
            getTopBoundary(other.y, other.height, pH) &&
        getTopBoundary(y, height, pH) <=
            getBottomBoundary(other.y, other.height, pH)) {
      // No collision if left of other
      if (getRightBoundary(x, width, pW) <
          getLeftBoundary(other.x, other.width, pW)) return false;

      // No collision if right of other
      if (getLeftBoundary(x, width, pW) >
          getRightBoundary(other.x, other.width, pW)) return false;

      return true;
    }
    return false;
  }

  double getBottomBoundary(double posY, double height, double pixelHeight) {
    double bottomPart = 0.5 - posY / 2;
    return posY + pixelHeight * height * bottomPart;
  }

  double getTopBoundary(double posY, double height, double pixelHeight) {
    double topPart = 0.5 + posY / 2;
    return posY - pixelHeight * height * topPart;
  }

  double getRightBoundary(double posX, double width, double pixelWidth) {
    double rightPart = 0.5 - posX / 2;
    return posX + pixelWidth * width * rightPart;
  }

  double getLeftBoundary(double posX, double width, double pixelWidth) {
    double leftPart = 0.5 + posX / 2;
    return posX - pixelWidth * width * leftPart;
  }
}
