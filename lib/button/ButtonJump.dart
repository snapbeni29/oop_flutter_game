import 'package:flutter/material.dart';

class ButtonJump extends StatefulWidget{
  final icon; // icon of the button
  final start; // function when tap

  ButtonJump({this.icon, this.start});

  @override
  _ButtonJumpState createState() => _ButtonJumpState();
}

class _ButtonJumpState extends State<ButtonJump> {
  /* The height of the jump will vary with the intensity of the tap:
      If one taps quickly, it will not jump high;
      If one taps for a certain time (0.3s e.g.), it will jump higher.
   */
  final double _minVelocity = 3.5;
  final Stopwatch sw = new Stopwatch();

  Widget build(BuildContext context) {
    return GestureDetector(
      // The clock starts as soon as one touches the button
      onTapDown: (details){
        if(!sw.isRunning) {
          setState(() {
            sw.start();
          });
        }
      },
      /* When no more contact, jump with a velocity that depends on the
          elapsed time of the contact.
       */
      onTapUp: (details){
        if(sw.isRunning) {
          widget.start(sw.elapsedMilliseconds / 200 + _minVelocity);
          setState(() {
            sw.stop();
            sw.reset();
          });
        }
      },
      /* To avoid high velocities, once the contact is considered a
          "long press" (400ms), jump with the max velocity
       */
      onLongPressStart: (details){
        if(sw.isRunning) {
          widget.start(sw.elapsedMilliseconds / 200 + _minVelocity);
          setState(() {
            sw.stop();
            sw.reset();
          });
        }
      },
      // TODO : Same code with onTapUp and onLongPressStart

      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: sw.isRunning ? Colors.white : Colors.greenAccent,
          ),
          padding: EdgeInsets.all(10),
          child: widget.icon,
        ),
      ),
    );
  }
}
