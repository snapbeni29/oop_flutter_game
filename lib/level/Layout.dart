import 'package:flutter/material.dart';
import 'package:flutter_app_mario/hit_box/Body.dart';
import 'package:flutter_app_mario/level/Enemy.dart';
import 'package:flutter_app_mario/level/Platform.dart';

/*
  A layout represents a level.
  A layout consists in a set of platforms and a set of enemies
    When a Level is created, it first uses createPlatforms(),
    then createEnemies(), because enemies can be associated to a platform.
 */

class Layout {
  List<Platform> _platformList;

  List<Platform> createPlatforms(BuildContext context) {
    _platformList = new List();

    // bottom right
    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: 1.0,
        y: 1.0,
      ),
    ));

    // top right
    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 1.0,
        y: -1.0,
      ),
    ));

    // top left
    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: -1.0,
        y: -0.5,
      ),
    ));

    // center
    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 0.0,
        y: 0.25,
      ),
    ));


    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 3.0,
        y: 0.5,
      ),
    ));


    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 4.0,
        y: 0.3,
      ),
    ));


    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 5.0,
        y: 0.1,
      ),
    ));


    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4 * 3,
        x: 6.0,
        y: 1,
      ),
    ));


    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 7.15,
        y: 0.3,
      ),
    ));


    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 8.0,
        y: 0.6,
      ),
    ));


    _platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4 * 3,
        x: 9.0,
        y: 1,
      ),
    ));

    return _platformList;
  }

  List<Enemy> createEnemies(BuildContext context) {
    if(_platformList == null)
      return new List<Enemy>();

    List<Enemy> enemyList = new List();

    //double pixelWidth = 2.0 / MediaQuery.of(context).size.width;
    double pixelHeight = 2.0 / (MediaQuery.of(context).size.height * 5.0 / 7.0);

    double height = (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0;
    double width = MediaQuery.of(context).size.width / 12.0;

    enemyList.add(new Enemy(
      maxHealth: 3,
      platform: _platformList[0],
      body: new Body(
        width: width,
        height: height,
        x: _platformList[0].body.x,
        y: getTopBoundary(_platformList[0].body.y, _platformList[0].body.height,
                pixelHeight) -
            height * pixelHeight / 2.0,
      ),
    ));

    /*
    enemyList.add(new Enemy(
      maxHealth: 3,
      body: new Body(
        width: MediaQuery.of(context).size.width / 12.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: -1.0,
        y: 0.5,
      ),
    ));
     */

    return enemyList;
  }
}
