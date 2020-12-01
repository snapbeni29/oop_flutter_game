import 'package:corona_bot/constants.dart';
import 'package:flutter/material.dart';

class ButtonInstant extends StatefulWidget{
  final icon; // icon of the button
  final start; // function when tap

  final width;
  final height;

  ButtonInstant({this.icon, this.start, this.width, this.height});

  @override
  _ButtonInstantState createState() => _ButtonInstantState();
}

class _ButtonInstantState extends State<ButtonInstant> {
  ///  A simple button:
  ///    As soon as we touch it (onTapDown), it starts its application
  ///
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => widget.start(context),
      child: ClipRRect(
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: BUTTON_COLOR,
          ),
          padding: EdgeInsets.all(10),
          child: widget.icon,
        ),
      ),
    );
  }
}
