import 'package:corona_bot/Body.dart';
import 'package:corona_bot/controllers/obstacles/PlatformController.dart';
import 'package:corona_bot/models/obstacles/PlatformModel.dart';
import 'package:corona_bot/views/obstacles/PlatformView.dart';
import 'package:flutter/material.dart';

/// A platform that can be broken with projectiles
class BreakPlatformController extends PlatformController {
  BreakPlatformController(Body body, int maxHealth) : super.empty() {
    model = new PlatformModel.breakable(body: body, mHealth: maxHealth);
    view = new PlatformView();
  }

  bool get dead => model.dead;

  void damage() {
    model.damage();
  }

  @override
  Widget displayPlatform() {
    return view.displayPlatform(model.body, model.health);
  }
}
