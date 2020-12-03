import 'package:corona_bot/Body.dart';
import 'package:corona_bot/constants.dart';
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
          color: HURT_COLOR,
          border: Border.all(
            color: BORDER_COLOR,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: body.width * (health / maxHealth),
          height: body.width / 10.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: LIFE_COLOR,
          ),
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
