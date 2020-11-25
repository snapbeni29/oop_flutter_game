import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/obstacles/PlatformModel.dart';
import 'package:corona_bot/views/obstacles/PlatformView.dart';
import 'package:flutter/material.dart';

class PlatformController {
  PlatformModel _model;
  PlatformView _view;

  PlatformController(Body body) {
    _model = new PlatformModel(body: body);
    _view = new PlatformView();
  }

  void moveLeft(){
    _model.moveLeft();
  }

  void moveRight(){
    _model.moveRight();
  }

  Body get body => _model.body;

  Widget displayPlatform() {
    return _view.displayPlatform(_model.body);
  }
}
