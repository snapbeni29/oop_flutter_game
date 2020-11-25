import 'package:corona_bot/constants.dart';
import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/obstacles/ProjectileModel.dart';
import 'package:corona_bot/views/obstacles/ProjectileView.dart';
import 'package:flutter/material.dart';

class ProjectileController {
  ProjectileModel _model;
  ProjectileView _view;

  ProjectileController(Body body, Direction direction, bool blue){
    _model = new ProjectileModel(body: body, direction: direction, blue: blue);
    _view = new ProjectileView();
  }

  void travel(){
    _model.travel();
  }

  void moveLeft() {
    _model.moveLeft();
  }

  void moveRight() {
    _model.moveRight();
  }

  Body get body => _model.body;

  Direction get direction => _model.direction;

  bool get freezing => _model.blue;

  Widget displayProjectile() {
    return _view.displayProjectile(_model.direction, _model.body, _model.blue);
  }
}
