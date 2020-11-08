import 'package:flutter/material.dart';
import 'package:flutter_app_mario/hit_box/Body.dart';
import 'package:flutter_app_mario/level/Enemy.dart';
import 'package:flutter_app_mario/level/Platform.dart';

class Layout {
  List<Platform> createPlatforms(BuildContext context) {
    List<Platform> platformList = new List();

    // bottom right
    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: 1.0,
        y: 1.0,
      ),
    ));

    // top right
    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 1.0,
        y: -1.0,
      ),
    ));

    // top left
    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: -1.0,
        y: -0.5,
      ),
    ));

    // center
    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 0.0,
        y: 0.25,
      ),
    ));


    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 3.0,
        y: 0.5,
      ),
    ));


    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 4.0,
        y: 0.3,
      ),
    ));


    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 5.0,
        y: 0.1,
      ),
    ));


    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4 * 3,
        x: 6.0,
        y: 1,
      ),
    ));


    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 7.15,
        y: 0.3,
      ),
    ));


    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0,
        x: 8.0,
        y: 0.6,
      ),
    ));


    platformList.add(new Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4 * 3,
        x: 9.0,
        y: 1,
      ),
    ));

    return platformList;
  }

  List<Enemy> createEnemies(BuildContext context, List<Platform> platformList) {
    List<Enemy> enemyList = new List();

    //double pixelWidth = 2.0 / MediaQuery.of(context).size.width;
    double pixelHeight = 2.0 / (MediaQuery.of(context).size.height * 5.0 / 7.0);

    double height = (MediaQuery.of(context).size.height * 5.0 / 7.0) / 8.0;
    double width = MediaQuery.of(context).size.width / 12.0;

    enemyList.add(new Enemy(
      maxHealth: 3,
      platform: platformList[0],
      body: new Body(
        width: width,
        height: height,
        x: platformList[0].body.x,
        y: getTopBoundary(platformList[0].body.y, platformList[0].body.height,
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
