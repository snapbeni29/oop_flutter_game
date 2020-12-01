import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/obstacles/EnemyModel.dart';
import 'package:corona_bot/views/obstacles/EnemyView.dart';
import 'package:flutter/material.dart';

class EnemyController {
  EnemyModel model;
  EnemyView view;

  Stopwatch _frozenTimer = Stopwatch();

  EnemyController(Body body, int maxHealth, Body area, {int type = 3}) {
    model = new EnemyModel(
        body: body, maxHealth: maxHealth, area: area, type: type);
    view = new EnemyView();
  }

  void moveOnce(double pW) {
    if (_frozenTimer.isRunning && _frozenTimer.elapsedMilliseconds > 2000) {
      _frozenTimer.reset();
      _frozenTimer.stop();
      model.moveOnce(pW);
    } else if (!_frozenTimer.isRunning) {
      model.moveOnce(pW);
    }
  }

  void moveLeft() {
    model.moveLeft();
  }

  void moveRight() {
    model.moveRight();
  }

  void damage(bool frozen) {
    if (frozen) {
      if (_frozenTimer.isRunning)
        _frozenTimer.reset();
      else
        _frozenTimer.start();
    }
    model.damage();
  }

  Body get body => model.body;

  bool get dead => model.dead;

  Widget displayEnemy() {
    return view.displayEnemy(model.body, model.type);
  }

  Widget displayEnemyLife() {
    return view.displayHealthBar(model.body, model.health, model.maxHealth);
  }
}
