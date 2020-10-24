import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Projectile.dart';

class Player extends ChangeNotifier{

  String _direction = "right";
  bool _midRun = false;
  bool _midJump = false;

  double _playerX = 0;
  double _playerY = 1.05;

  int _runPos = 0;
  int _jumpPos = 5;

  double _time = 0;
  double _height = 0;
  double _initialHeight;

  List<Projectile> _projectileList = List();
  int _aliveProj = 0;
  int _maxProj = 3;
  bool _firstShoot = false;

  void jump(double velocity){
    // No double jump allowed --currently--
    if(_midJump)
      return;

    if(velocity <= 0.0)
      velocity = 4.0;

    _time = 0;
    _initialHeight = _playerY;
    _midJump = true;

    Timer.periodic(Duration(milliseconds: 60), (timer) {
      _time += 0.05;
      // Gravity equation
      _height = -4.9 * _time * _time + velocity * _time;

      // Collision detection
      if(_initialHeight - _height > 1.05){
        _midJump = false;
        _playerY = 1.05;
        timer.cancel();
        notifyListeners();
      }
      else{
        // Update
        _playerY = _initialHeight - _height;
        notifyListeners();
      }
    });
  }

  void stopRunRight(){
    if(_direction == 'right')
      _midRun = false;
  }

  void stopRunLeft(){
    if(_direction == 'left')
      _midRun = false;
  }

  void moveRight(){
    // If the player is currently holding left, we can't go right
    if(_direction == 'left' && _midRun)
      return;

    _direction = "right";
    _midRun = true;

    // Each 50ms, the position increases by a certain amount
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(_midRun){
        _playerX += 0.015;
        notifyListeners();
      }
      else{
        _runPos = 0;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void moveLeft(){
    // If the player is currently holding right, we can't go left
    if(_direction == 'right' && _midRun)
      return;

    _direction = "left";
    _midRun = true;

    // Each 50ms, the position increases by a certain amount
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(_midRun){
        _playerX -= 0.015;
        notifyListeners();
      }
      else{
        _runPos = 0;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  Widget displayPlayer() {
    Image img; // which sprite to display
    if(_midJump){
      img = Image.asset('images/Jump (' + _jumpPos.toString() +').png');
    }
    else if(_midRun){
      // Run animation : a different sprite in the pattern
      _runPos = (_runPos + 1) % 8;
      img = Image.asset('images/Run ('+ (_runPos + 1).toString() +').png');
    }
    else{
      img = Image.asset('images/Idle (1).png');
    }

    // The sprites are looking right initially
    if(_direction == 'right'){
      return Container(
        width: 80.0,
        height: 80.0,
        child: img,
      );
    }
    // When going left, we have to rotate the sprite by pi
    else{
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          width: 80.0,
          height: 80.0,
          child: img,
        ),
      );
    }
  }

  //  Projectile interactions

  void shoot() {
    if(_aliveProj < _maxProj) {
      if (!_firstShoot) {
        _firstShoot = true;
        _projectileList.add(Projectile(
            projectileX: (_playerX + 0.015),
            projectileY: _playerY - 0.15,
            direction: this._direction));
        startProj();
      } else {
        _projectileList.add(Projectile(
            projectileX: (_playerX + 0.015),
            projectileY: _playerY - 0.15,
            direction: this._direction));
      }
      _aliveProj++;
    }
  }

  void startProj() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(_projectileList.isEmpty){
        _firstShoot = false;
        timer.cancel();
      }
      for (Projectile proj in _projectileList) {
        if (proj.getDirection == "right") {
          proj.moveRight();
        } else {
          proj.moveLeft();
        }
      }
      notifyListeners();
    });
  }

  Widget displayProjectile() {
    if (_projectileList.isEmpty) return Container();
    List<Widget> widgetProjectileList = List();
    for (int i = 0; i < _projectileList.length; i++) {
      if(_projectileList.isEmpty){
        break;
      }
      if(_projectileList[i].direction == "right"){
        if(_projectileList[i].posX > 1.1){
          _aliveProj--;
          _projectileList.remove(_projectileList[i]);
        }
        else{
          widgetProjectileList.add(AnimatedContainer(
            alignment: Alignment(_projectileList[i].posX, _projectileList[i].posY),
            duration: Duration(milliseconds: 0),
            child: _projectileList[i].displayProjectile(),
          ));
        }
      }
      else{
        if(_projectileList[i].posX < -1.1){
          _aliveProj--;
          _projectileList.remove(_projectileList[i]);
        }
        else{
          widgetProjectileList.add(AnimatedContainer(
            alignment: Alignment(_projectileList[i].posX, _projectileList[i].posY),
            duration: Duration(milliseconds: 0),
            child: _projectileList[i].displayProjectile(),
          ));
        }
      }
    }
    return Stack(
      children: widgetProjectileList,
    );
  }

  // Get functions
  double get posX => _playerX;
  double get posY => _playerY;
}