import 'package:corona_bot/controllers/PlayerController.dart';
import 'package:corona_bot/controllers/obstacles/BossController.dart';
import 'package:corona_bot/controllers/obstacles/CollectableController.dart';
import 'package:corona_bot/controllers/obstacles/EnemyController.dart';
import 'package:corona_bot/controllers/obstacles/PlatformController.dart';
import 'package:flutter/material.dart';

class LevelView {
  Widget displayLevel(
      PlayerController player,
      List<PlatformController> platformList,
      List<EnemyController> enemyList,
      BossController boss,
      List<CollectableController> collectableList,
      double pixelHeight,
      bool collision) {
    List<Widget> widgetList = new List();

    // Platforms
    for (PlatformController pf in platformList) {
      widgetList.add(pf.displayPlatform());
    }

    // Player
    widgetList.add(
      AnimatedContainer(
        alignment: Alignment(player.x, player.y),
        duration: Duration(milliseconds: 0),
        child: player.displayPlayer(collision),
      ),
    );

    // Life bar
    widgetList.add(
      AnimatedContainer(
        alignment: Alignment(0.0, -0.9),
        duration: Duration(milliseconds: 0),
        child: player.displayPlayerLife(),
      ),
    );

    //Projectiles
    widgetList.add(player.displayProjectile(platformList, enemyList, boss));

    // Enemies
    for (EnemyController enemy in enemyList) {
      widgetList.add(
        AnimatedContainer(
          alignment: Alignment(enemy.body.x, enemy.body.y),
          duration: Duration(milliseconds: 0),
          child: enemy.displayEnemy(),
        ),
      );
      // With their health bar
      widgetList.add(
        AnimatedContainer(
          alignment:
              Alignment(enemy.body.x, enemy.body.getTopBoundary(pixelHeight)),
          duration: Duration(milliseconds: 0),
          child: enemy.displayEnemyLife(),
        ),
      );
    }

    // Boss
    if (!boss.dead) {
      widgetList.add(
        AnimatedContainer(
          alignment: Alignment(boss.body.x, boss.body.y),
          duration: Duration(milliseconds: 0),
          child: boss.displayEnemy(),
        ),
      );
      // With their health bar
      widgetList.add(
        AnimatedContainer(
          alignment:
              Alignment(boss.body.x, boss.body.getTopBoundary(pixelHeight)),
          duration: Duration(milliseconds: 0),
          child: boss.displayEnemyLife(),
        ),
      );
      // Boss projectiles
      if (boss.isShooting) {
        widgetList.add(boss.displayProjectile(platformList, player));
      }
    }

    // Collectables
    for (CollectableController collectable in collectableList) {
      widgetList.add(collectable.displayCollectable());
    }

    return Stack(
      children: widgetList,
    );
  }
}
