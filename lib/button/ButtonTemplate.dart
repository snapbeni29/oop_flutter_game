import 'package:flutter/material.dart';
import 'package:flutter_app_mario/button/ButtonJump.dart';
import 'package:flutter_app_mario/button/ButtonRun.dart';
import 'package:flutter_app_mario/button/ButtonInstant.dart';
import 'package:flutter_app_mario/button/ButtonType.dart';

/*
  This class creates a special button depending on the type
  (cfr. ButtonType).

  TODO: currently, it is not really a 'template' and it is not really
    necessary (we could simply create a ButtonRun directly e.g.)
      To modify if possible, else remove
 */

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
