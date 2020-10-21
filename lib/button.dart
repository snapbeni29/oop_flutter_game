import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{

  final child;
  final function;
  static bool holdingButton = false;

  MyButton({this.child, this.function});

  bool userIsHoldingButton(){
    return holdingButton;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details){
        holdingButton = true;
        function();
      },
      onTapUp: (details){
        holdingButton = false;
      },
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.greenAccent,
          ),
          margin: EdgeInsets.symmetric(horizontal: 70),
          padding: EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }

}