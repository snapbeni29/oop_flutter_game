import 'package:flutter/material.dart';
import 'package:flutter_app_mario/hit_box/Body.dart';
import 'package:flutter_app_mario/level/Enemy.dart';
import 'package:flutter_app_mario/level/Platform.dart';

class Layout{
  List<Platform> createPlatforms(BuildContext context){
    List<Platform> platformList = new List();

    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: 1.0,
        y: 1.0,
      ),
    ));

    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 1.0,
        y: -1.0,
      ),
    ));

    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: -1.0,
        y: -0.5,
      ),
    ));

    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 8.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 0.0,
        y: 0.25,
      ),
    ));

    return platformList;
  }

  List<Enemy> createEnemies(BuildContext context){
    List<Enemy> enemyList = new List();

    enemyList.add(new Enemy(
      maxHealth: 3,
      name: 345,
      body: new Body(
        width: MediaQuery.of(context).size.width / 8.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 1.0,
        y: 0.5,
      ),
    ));

    enemyList.add(new Enemy(
      maxHealth: 3,
      name: 456,
      body: new Body(
        width: MediaQuery.of(context).size.width / 8.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: -1.0,
        y: 0.5,
      ),
    ));

    return enemyList;
  }
}
