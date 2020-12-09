import 'package:corona_bot/constants.dart';
import 'package:corona_bot/layouts/LayoutBaseBlocs.dart';

/// Layout of level #1
///    Extends LayoutBaseBlocs such that it implements the createLayout() function
///    and uses the different blocs defined there.
///    Doing so, it is easier to see what is done in the level.
///
class LayoutLevel1 extends LayoutBaseBlocs {
  LayoutLevel1() {
    createLayout();
  }

  void createLayout() {
    wall(-5.5, 4, 1);
    normalLEnemy(-4.5, 2);
    middleHCollectable(-3.25, 2, COIN);
    groundEnemy(-2.75, 3);
    bridgeEnemy(-1.5, -0.5, 2);
    reverseLEnemy(-1.25, 3);
    tunnelCollectable(0.75, 2, BLUE_POTION);
    bridge(1.75, -0.5, 1);
    groundEnemy(2.25, 3);
    leftTCollectable(2.75, 2, GREEN_POTION);
    bridge(3.75, 1, 1);
    rightTEnemy(4.25, 2);
    groundEnemy(4.5, 4);
    singleCollectable(5, 0, COIN);
    wallBreak(5.25);
    groundCollectable(5.5, RED_POTION);
    tunnelEnemy(6, 4);
    bossEnemy(8);
    groundCollectable(9, END_FLAG);
  }
}
