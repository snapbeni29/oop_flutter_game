
double getBottomBoundarie(double posY, double height, double pixelHeight){
  double bottomPart = 0.5 - posY / 2;

  return posY + pixelHeight * height * bottomPart;
}

double getTopBoundarie(double posY, double height, double pixelHeight){
  double topPart = 0.5 + posY / 2;

  return posY - pixelHeight * height * topPart;
}

double getRightBoundarie(double posX, double width, double pixelWidth){
  double rightPart = 0.5 - posX / 2;

  return posX + pixelWidth * width * rightPart;
}

double getLeftBoundarie(double posX, double width, double pixelWidth){
  double leftPart = 0.5 + posX / 2;

  return posX - pixelWidth * width * leftPart;
}

double getPlayerRightBoundarie(double pixelWidth){
  return pixelWidth * 80 * 0.26;
}

double getPlayerLeftBoundarie(double pixelWidth){
  return -pixelWidth * 80 * 0.26;
}


double getPlayerTopBoundarie(double posY, double pixelHeight){
  double topPart = 0.5 + posY / 2;

  return posY - pixelHeight * 80 * topPart;
}

double getPlayerBottomBoundarie(double posY, double pixelHeight){
  double bottomPart = 0.5 - posY / 2;

  return posY + pixelHeight * 80 * bottomPart;
}