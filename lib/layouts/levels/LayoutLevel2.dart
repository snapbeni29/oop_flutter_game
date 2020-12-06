import 'package:corona_bot/constants.dart';
import 'package:corona_bot/layouts/LayoutBaseBlocs.dart';

/// Layout of level #2
///    Extends LayoutBaseBlocs such that it implements the createLayout() function
///    and uses the different blocs defined there.
///    Doing so, it is easier to see what is done in the level.
///
class LayoutLevel2 extends LayoutBaseBlocs {
  LayoutLevel2() {
    createLayout();
  }

  void createLayout() {
    wall(-1.5, 5, 1);
    bridgeEnemy(0.5,0.8, 2);
    groundEnemy(1.5, 4);
    bridgeCollectable(1.25, 0.5, 1.5, BLUE_POTION);
    wall(2, 2, 1.5);
    groundEnemy(2.65, 6);
    tunnelEnemy(3, 2);
    bridgeCollectable(3.75, 0.25, 1, COIN);
    leftTEnemy(4.25, 2);
    reverseLEnemy(5, 2);
    singleCollectable(5.25, -0.95, GREEN_POTION);
    groundCollectable(5.75, COIN);
    wallBreak(6);
    bridgeEnemy(6.5, -0.5, 2);
    singleCollectable(6.76, -0.8, RED_POTION);
    wallBreak(7.25);
    bossEnemy(8.5);
    groundCollectable(9.5, END_FLAG);
  }
}
