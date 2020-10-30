import 'package:flutter/material.dart';

class ButtonShoot extends StatefulWidget{
  final icon; // icon of the button
  final start; // function when tap

  ButtonShoot({this.icon, this.start});

  @override
  _ButtonShootState createState() => _ButtonShootState();
}

class _ButtonShootState extends State<ButtonShoot> {

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