import 'package:corona_bot/constants.dart';
import 'package:corona_bot/layouts/LayoutBaseBlocs.dart';

/// Layout of level #1
///    Extends LayoutBaseBlocs such that it implements the createLayout() function
///    and uses the different blocs defined there.
///    Doing so, it is easier to see what is done in the level.
///
class LayoutLevel3 extends LayoutBaseBlocs {
  LayoutLevel3() {
    createLayout();
  }

  void createLayout() {
    wall(-1.5, 5, 1);
    bridge(0, -0.2, 1);
    singleCollectable(0, -0.5, COIN);
    bridge(0.5, 0.5, 2);
    bridge(0.5, 0.8, 2);
    bridgeEnemy(0.5, -0.5, 2);
    groundEnemy(1.3, 4);
    bridge(1.5, 0.5, 1);
    singleCollectable(1.5, -0.8, BLUE_POTION);
    groundEnemy(1.9, 6);
    wall(2.3, 2, 1.2);
    groundEnemy(3, 6);
    groundEnemy(3.3, 6);
    groundCollectable(3.2, COIN);
    middleHEnemy(3.5, 2);
    singleCollectable(3.85, -0.3, GREEN_POTION);
    //leftTEnemy(4.25, 2);
    reverseLEnemy(5, 2);
    tunnelEnemy(6, 4);
    singleEnemy(6.25, 0.4, 4);
    singleEnemy(6.5, 0.4, 4);
    singleCollectable(6.5, 0.4, RED_POTION);
    singleEnemy(6.75, 0.4, 4);
    singleEnemy(7.55, -0.75, 6);
    leftTEnemy(7.5, 2);
    groundEnemy(9.25, 2);
    groundEnemy(9.5, 2);
    groundEnemy(9.75, 2);
    bossEnemy(10.5);
    groundCollectable(11, END_FLAG);
  }
}
