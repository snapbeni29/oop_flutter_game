import 'package:corona_bot/constants.dart';
import 'package:flutter/material.dart';

class ButtonRun extends StatefulWidget{
  final icon; // icon of the button
  final start; // function when tap
  final end; // function when no more contact

  final width;
  final height;

  ButtonRun({this.icon, this.start, this.end, this.width, this.height});

  @override
  _ButtonRunState createState() => _ButtonRunState();
}

class _ButtonRunState extends State<ButtonRun> {
  /* The button will differ depending on _holdingButton:
        - White when pressed
        - Green otherwise

     We use setState when we change the boolean to display
     the other version of the button.
  */
  bool _holdingButton = false;

  Widget build(BuildContext context) {
    return GestureDetector(
      // Tap on the button
      onTapDown: (details){
        setState(() {
          _holdingButton = true;
        });
        widget.start();
      },
      // Release the button
      onTapUp: (details){
        setState(() {
          _holdingButton = false;
        });
        widget.end();
      },
      // Release somewhere different than the button
      onScaleEnd: (details){
        setState(() {
          _holdingButton = false;
        });
        widget.end();
      },

      child: ClipRRect(
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: _holdingButton ? BUTTON_PRESSED : BUTTON_COLOR,
          ),
          padding: EdgeInsets.all(10),
          child: widget.icon,
        ),
      ),
    );
  }
}
