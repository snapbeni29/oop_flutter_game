import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/PlayerController.dart';
import 'package:corona_bot/controllers/obstacles/BossController.dart';
import 'package:corona_bot/controllers/obstacles/CollectableController.dart';
import 'package:corona_bot/controllers/obstacles/EnemyController.dart';
import 'package:corona_bot/controllers/obstacles/PlatformController.dart';
import 'package:corona_bot/layouts/LayoutBaseBlocs.dart';
import 'package:corona_bot/layouts/LayoutConstants.dart';
import 'package:corona_bot/layouts/levels/LayoutLevel1.dart';
import 'package:corona_bot/Body.dart';
import 'package:flutter/material.dart';

/// This class loads a layout based on the levelNumber received as parameter.
///  The level can then use the different functions create...() to retrieve
///  the different obstacles in the level.
///
class Layout {
  List<PlatformController> _platformList = new List();
  List<EnemyController> _enemyList = new List();
  List<CollectableController> _collectableList = new List();

  LayoutBaseBlocs _layout;

  final int levelNumber;
  double height;
  double width;

  Layout(BuildContext context, {this.levelNumber}) {
    switch (levelNumber) {
      case 1:
        {
          _layout = LayoutLevel1();
        }
        break;
      default:
        {
          debugPrint("Error while creating layout in level: " +
              levelNumber.toString());
          // Return error
        }
        break;
    }

    height = (MediaQuery.of(context).size.height * 5.0 / 7.0);
    width = MediaQuery.of(context).size.width;
  }

  /// Creates all the Platforms of the level [levelNumber] and returns the list
  /// of all their controllers.
  List<PlatformController> createPlatforms() {
    List<BodyConstants> platformsBody = _layout.getPlatforms;

    for (var i = 0; i < platformsBody.length; i++) {
      _platformList.add(
        new PlatformController(
          new Body(
            width: width / platformsBody[i].w,
            height: height / platformsBody[i].h,
            x: platformsBody[i].x,
            y: platformsBody[i].y,
          ),
        ),
      );
    }

    return _platformList;
  }

  /// Creates all the Enemies of the level [levelNumber] and returns the list
  /// of all their controllers.
  List<EnemyController> createEnemies() {
    List<BodyConstants> enemiesBody = _layout.getEnemyAreas;

    for (var i = 0; i < enemiesBody.length; i++) {
      _enemyList.add(
        new EnemyController(
          new Body(
            width: width / 12.0,
            height: height / 8.0,
            x: enemiesBody[i].x,
            y: enemiesBody[i].y,
          ),
          3,
          new Body(
            width: width / enemiesBody[i].w,
            height: height / enemiesBody[i].h,
            x: enemiesBody[i].x,
            y: enemiesBody[i].y,
          ),
        ),
      );
    }

    return _enemyList;
  }

  /// Creates the Boss of the level [levelNumber] and returns its controller
  BossController createBoss(double pw, double ph, PlayerController player) {
    BodyConstants bossLevel = _layout.getBossEnemy;

    return BossController(
      pw,
      ph,
      Body(
        width: width / bossWidth,
        height: height / bossHeight,
        x: bossLevel.x,
        y: bossLevel.y,
      ),
      Body(
        width: width / bossLevel.w,
        height: height / bossLevel.h,
        x: bossLevel.x,
        y: bossLevel.y,
      ),
      player,
      4,
    );
  }

  /// Creates all the Collectables of the level [levelNumber] and returns the
  /// list of all their controllers.
  List<CollectableController> createCollectables() {
    List<BodyConstants> collectablesBody = _layout.getCollectables;

    for (var i = 0; i < collectablesBody.length; i++) {
      double heightDivisor = collectablesBody[i].collectable == END_FLAG
          ? 1 // full screen
          : collectablesBody[i].h; // normal size
      double widthDivisor = collectablesBody[i].collectable == END_FLAG
          ? 80 // narrower
          : collectablesBody[i].w; // normal size

      _collectableList.add(
        new CollectableController(
          new Body(
            // hit-box of the collectable
            width: width / widthDivisor,
            height: height / heightDivisor,
            x: collectablesBody[i].x,
            y: collectablesBody[i].y,
          ),
          collectablesBody[i].collectable,
          new Body(
            // area to move the collectable
            width: width / platformWidth,
            height: height / collectablesBody[i].h,
            x: collectablesBody[i].x,
            y: collectablesBody[i].y,
          ),
        ),
      );
    }

    return _collectableList;
  }
}
