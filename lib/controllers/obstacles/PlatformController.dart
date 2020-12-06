import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/obstacles/PlatformModel.dart';
import 'package:corona_bot/views/obstacles/PlatformView.dart';
import 'package:flutter/material.dart';

class PlatformController {
  PlatformModel model;
  PlatformView view;

  PlatformController.empty();

  PlatformController(Body body) {
    model = new PlatformModel(body: body);
    view = new PlatformView();
  }

  void moveLeft(){
    model.moveLeft();
  }

  void moveRight(){
    model.moveRight();
  }

  Body get body => model.body;

  Widget displayPlatform() {
    return view.displayPlatform(model.body, -1);
  }
}
