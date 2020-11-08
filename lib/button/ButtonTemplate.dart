import 'package:flutter/material.dart';
import 'package:flutter_app_mario/button/ButtonJump.dart';
import 'package:flutter_app_mario/button/ButtonRun.dart';
import 'package:flutter_app_mario/button/ButtonInstant.dart';
import 'package:flutter_app_mario/button/ButtonType.dart';

class ButtonTemplate extends StatefulWidget{
  final ButtonType type;
  final icon; // icon of the button
  final start; // function when tap
  final end; // function when no more contact

  ButtonTemplate({this.type, this.icon, this.start, this.end});

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<ButtonTemplate> {

  Widget build(BuildContext context) {
    if(widget.type == ButtonType.run) {
      return new ButtonRun(
        icon: widget.icon,
        start: widget.start,
        end: widget.end,
      );
    }
    else if(widget.type == ButtonType.jump){
      return new ButtonJump(
        icon: widget.icon,
        start: widget.start,
      );
    }
    else{
      return new ButtonInstant(
        icon: widget.icon,
        start: widget.start,
      );
    }
  }
}
