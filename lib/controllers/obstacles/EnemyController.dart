import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/obstacles/EnemyModel.dart';
import 'package:corona_bot/views/obstacles/EnemyView.dart';
import 'package:flutter/material.dart';

class EnemyController {
  EnemyModel _model;
  EnemyView _view;

  Stopwatch _frozenTimer = Stopwatch();

  EnemyController(Body body, int maxHealth, Body area) {
    _model = new EnemyModel(body: body, maxHealth: maxHealth, area: area);
    _view = new EnemyView();
  }

  void moveOnce(double pW) {
    if (_frozenTimer.isRunning && _frozenTimer.elapsedMilliseconds > 2000) {
      _frozenTimer.reset();
      _frozenTimer.stop();
      _model.moveOnce(pW);
    } else if (!_frozenTimer.isRunning) {
      _model.moveOnce(pW);
    }
  }

  void moveLeft() {
    _model.moveLeft();
  }

  void moveRight() {
    _model.moveRight();
  }

  void damage(bool frozen) {
    if (frozen) {
      if (_frozenTimer.isRunning)
        _frozenTimer.reset();
      else
        _frozenTimer.start();
    }
    _model.damage();
  }

  Body get body => _model.body;

  bool get dead => _model.dead;

  Widget displayEnemy() {
    return _view.displayEnemy(_model.body);
  }

  Widget displayEnemyLife() {
    return _view.displayHealthBar(_model.body, _model.health, _model.maxHealth);
  }
}
