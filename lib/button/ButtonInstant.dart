import 'package:flutter/material.dart';

class ButtonInstant extends StatefulWidget{
  final icon; // icon of the button
  final start; // function when tap

  ButtonInstant({this.icon, this.start});

  @override
  _ButtonInstantState createState() => _ButtonInstantState();
}

class _ButtonInstantState extends State<ButtonInstant> {
  /*
    A simple button:
      As soon as we touch it (onTapDown), it starts its application
   */

  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => widget.start(),

      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.greenAccent,
          ),
          padding: EdgeInsets.all(10),
          child: widget.icon,
        ),
      ),
    );
  }
}