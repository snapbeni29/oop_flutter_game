import 'package:corona_bot/Body.dart';
import 'package:corona_bot/models/obstacles/CollectableModel.dart';
import 'package:corona_bot/views/obstacles/CollectableView.dart';
import 'package:flutter/material.dart';

class CollectableController{
  CollectableModel _model;
  CollectableView _view;

  CollectableController(Body body, String type, Body area){
    _model = CollectableModel(body: body, type: type, area: area);
    _view = CollectableView();
  }

  void moveRight(double pixelWidth){
    _model.moveRightArea(pixelWidth);
  }

  void moveLeft(double pixelWidth){
    _model.moveLeftArea(pixelWidth);
  }

  Widget displayCollectable() {
    return _view.displayCollectable(_model.body, _model.type);
  }

  Body get body => _model.body;

  String get type => _model.type;
}