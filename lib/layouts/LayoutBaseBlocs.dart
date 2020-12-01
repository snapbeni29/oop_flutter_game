import 'package:corona_bot/layouts/LayoutConstants.dart';

/// This class implements functions that can be used to create a layout.
///    As it is an abstract class, a level can extend this class and use the
///    functions defined (the "base blocs" of the game) to create a level.
///
abstract class LayoutBaseBlocs {
  List<BodyConstants> _platformList = new List();
  List<BodyConstants> _enemyList = new List();
  BodyConstants _boss;
  List<BodyConstants> _collectableList = new List();

  void createLayout();

  // Platforms -----------------------------------------------------------------

  void singlePlatform(double x, double y, double height) {
    _platformList.add(BodyConstants(x: x, y: y, w: platformWidth, h: height));
  }

  /// A set of "length" platforms together
  void platforms(double x, double y, double length, double height) {
    for (double i = 0; i < length; i++) {
      singlePlatform(x + i * spacing, y, height);
    }
  }

  /// A set of platforms that start on the ground (y=1)
  void wall(double x, double length, double height) {
    platforms(x, 1, length, height);
  }

  // Single enemy --------------------------------------------------------------

  void singleEnemy(double x, double y, double width) {
    _enemyList.add(BodyConstants(x: x, y: y, w: width, h: areaHeight));
  }

  /// An enemy on the ground (y=1)
  void groundEnemy(double x, double width) {
    singleEnemy(x, 1, width);
  }

  /// A boss will always be on the ground and is of fixed size
  void bossEnemy(double x) {
    _boss = new BodyConstants(x: x, y: 1, w: bossWidth/1.4, h: bossHeight);
  }

  // Single collectable --------------------------------------------------------

  /// The "collectable" parameter must take a value defined in the
  /// 'constants.dart' file
  void singleCollectable(double x, double y, String collectable) {
    _collectableList.add(BodyConstants(
        x: x,
        y: y,
        w: collectableWidth,
        h: collectableHeight,
        collectable: collectable));
  }

  /// An collectable on the ground (y=1)
  void groundCollectable(double x, String collectable) {
    _collectableList.add(BodyConstants(
        x: x,
        y: 1,
        w: collectableWidth,
        h: collectableHeight,
        collectable: collectable));
  }

  /* ---------------------------------------------------------------------- */
  /* For each following type of bloc (set of platforms to create a -------- */
  /*  specific shape), we will define it with two other functions:--------- */
  /*    - one with an enemy on top and in the middle ---------------------- */
  /*    - one with a collectable on top and in the middle------------------ */
  /*  See first example in bridge ----------------------------------------- */
  /* ---------------------------------------------------------------------- */

  // A "bridge" is a set of platforms of fixed height = 8 ----------------------

  double _yOnBridge = 0.3;

  void bridge(double x, double y, double length) {
    platforms(x, y, length, 8);
  }

  /// Example: bridgeEnemy creates a bridge() then adds a single enemy on top
  void bridgeEnemy(double x, double y, double length) {
    bridge(x, y, length);
    singleEnemy(x + spacing * (length - 1) / 2, y - _yOnBridge,
        2 * platformWidth / length);
  }

  void bridgeCollectable(
      double x, double y, double length, String collectable) {
    bridge(x, y, length);
    singleCollectable(
        x + spacing * (length - 1) / 2, y - _yOnBridge, collectable);
  }

  // A "tunnel" is always centered (y=1 and y=-1) ------------------------------

  double _yOnTunnel = 0.4;

  void tunnel(double x, double length) {
    platforms(x, 1, length, 4);
    platforms(x, -1, length, 4);
  }

  void tunnelEnemy(double x, double length) {
    tunnel(x, length);
    singleEnemy(
        x + spacing * (length - 1) / 2, _yOnTunnel, 2 * platformWidth / length);
  }

  void tunnelCollectable(double x, double length, String collectable) {
    tunnel(x, length);
    singleCollectable(x + spacing * (length - 1) / 2, _yOnTunnel, collectable);
  }

  // An "L" is always on the ground (y=1) --------------------------------------

  double _yOnL = 0.7;

  void normalL(double x, double length) {
    singlePlatform(x, 1, 2);
    bridge(x + spacing, 1, length);
  }

  void normalLEnemy(double x, double length) {
    normalL(x, length);
    singleEnemy(x + spacing + spacing * (length - 1) / 2, _yOnL,
        2 * platformWidth / length);
  }

  void normalLCollectable(double x, double length, String collectable) {
    normalL(x, length);
    singleCollectable(
        x + spacing + spacing * (length - 1) / 2, _yOnL, collectable);
  }

  void reverseL(double x, double length) {
    bridge(x, 1, length);
    singlePlatform(x + length * spacing, 1, 2);
  }

  void reverseLEnemy(double x, double length) {
    reverseL(x, length);
    singleEnemy(
        x + spacing * (length - 1) / 2, _yOnL, 2 * platformWidth / length);
  }

  void reverseLCollectable(double x, double length, String collectable) {
    reverseL(x, length);
    singleCollectable(
        x + spacing + spacing * (length - 1) / 2, _yOnL, collectable);
  }

  // A "T" or "H" is always in the middle (y=0) --------------------------------

  double _yOnT = -0.3;

  void leftT(double x, double length) {
    singlePlatform(x, 0, 2);
    bridge(x + spacing, 0, length);
  }

  void leftTEnemy(double x, double length) {
    leftT(x, length);
    singleEnemy(x + spacing + spacing * (length - 1) / 2, _yOnT,
        2 * platformWidth / length);
  }

  void leftTCollectable(double x, double length, String collectable) {
    leftT(x, length);
    singleCollectable(
        x + spacing + spacing * (length - 1) / 2, _yOnT, collectable);
  }

  void rightT(double x, double length) {
    bridge(x, 0, length);
    singlePlatform(x + length * spacing, 0, 2);
  }

  void rightTEnemy(double x, double length) {
    rightT(x, length);
    singleEnemy(
        x + spacing * (length - 1) / 2, _yOnT, 2 * platformWidth / length);
  }

  void rightTCollectable(double x, double length, String collectable) {
    rightT(x, length);
    singleCollectable(x + spacing * (length - 1) / 2, _yOnT, collectable);
  }

  void middleH(double x, double length) {
    singlePlatform(x, 0, 2);
    rightT(x + spacing, length);
  }

  void middleHEnemy(double x, double length) {
    singlePlatform(x, 0, 2);
    rightTEnemy(x + spacing, length);
  }

  void middleHCollectable(double x, double length, String collectable) {
    singlePlatform(x, 0, 2);
    rightTCollectable(x + spacing, length, collectable);
  }

  // Getters -------------------------------------------------------------------

  List<BodyConstants> get getPlatforms => _platformList;

  List<BodyConstants> get getEnemyAreas => _enemyList;

  BodyConstants get getBossEnemy => _boss;

  List<BodyConstants> get getCollectables => _collectableList;
}
