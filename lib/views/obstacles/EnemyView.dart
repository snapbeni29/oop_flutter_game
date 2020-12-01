import 'package:corona_bot/Body.dart';
import 'package:corona_bot/controllers/obstacles/ProjectileController.dart';
import 'package:flutter/material.dart';

class EnemyView {
  Widget displayEnemy(Body body, int type) {
    return Container(
      width: body.width,
      height: body.height,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.asset('images/Monsters/virus' + type.toString() + '.png'),
      ),
    );
  }

  Widget displayHealthBar(Body body, int health, int maxHealth) {
    return Container(
      width: body.width,
      height: body.width / 10.0,
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Container(
          width: body.width * (health / maxHealth),
          height: body.width / 10.0,
          color: Colors.lightGreen,
        ),
      ),
    );
  }

  Widget displayProjectiles(List<ProjectileController> projectileList) {
    List<Widget> widgetProjectileList = new List();

    for (ProjectileController projectile in projectileList) {
      widgetProjectileList.add(AnimatedContainer(
        alignment: Alignment(projectile.body.x, projectile.body.y),
        duration: Duration(milliseconds: 0),
        child: projectile.displayProjectile(),
      ));
    }

    return Stack(
      children: widgetProjectileList,
    );
  }
}
