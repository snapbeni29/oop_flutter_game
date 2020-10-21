import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/projectile.dart';
import 'button.dart';

class Player extends ChangeNotifier{

  String direction = "right";
  bool midRun = false;
  bool midJump = false;

  List<Projectile> projectileList = List();

  static double playerX = 0;
  static double playerY = 1.05;

  int runPos = 0;
  int jumpPos = 5;

  double time = 0;
  double height = 0;
  double initialHeight = playerY;

  void preJump(){
    this.time = 0;
    this.initialHeight = playerY;
  }


  void jump(){
    preJump();
    midJump = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 4 * time;
      if(initialHeight - height > 1.05){
        midJump = false;
        playerY = 1.05;
        timer.cancel();
        notifyListeners();
      }
      else {
        playerY = initialHeight - height;
        notifyListeners();
      }
    });
  }

  void moveRight(){
    direction = "right";
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(MyButton().userIsHoldingButton() == true){
        midRun = true;
        playerX += 0.015;
        notifyListeners();
      }
      else{
        midRun = false;
        runPos = 0;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void moveLeft(){
    direction = "left";
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(MyButton().userIsHoldingButton() == true){
        midRun = true;
        playerX -= 0.015;
        notifyListeners();
      }
      else{
        midRun = false;
        runPos = 0;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void shoot(){
    projectileList.add(Projectile(projectileX: (playerX + 0.015), projectileY: playerY, direction: this.direction));
    notifyListeners();
  }

  Widget displayPlayer(){
    if(direction == 'right'){
      if(midJump){
        return Container(
          width: 80.0,
          height: 80.0,
          child: Image.asset('images/Jump (' + jumpPos.toString() +').png'),
        );
      }
      else if(midRun){
        runPos = (runPos + 1) % 8;
        return Container(
          width: 80.0,
          height: 80.0,
          child: Image.asset('images/Run ('+ (runPos + 1).toString() + ').png'),
        );
      }
      else{
        return Container(
          width: 80.0,
          height: 80.0,
          child: Image.asset('images/Idle (1).png'),
        );
      }
    }
    else{
      if(midJump){
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Container(
            width: 80.0,
            height: 80.0,
            child: Image.asset('images/Jump (5).png'),
          ),
        );
      }
      else if(midRun){
        runPos = (runPos + 1) % 8;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Container(
            width: 80.0,
            height: 80.0,
            child: Image.asset('images/Run ('+ (runPos + 1).toString() + ').png'),
          ),
        );
      }
      else{
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: Container(
            width: 80.0,
            height: 80.0,
            child: Image.asset('images/Idle (1).png'),
          ),
        );
      }
    }
  }
  double get posX => playerX;
  double get posY => playerY;
}