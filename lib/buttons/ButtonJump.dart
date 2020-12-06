import 'dart:math';

import 'package:corona_bot/constants.dart';
import 'package:flutter/material.dart';

class ButtonJump extends StatefulWidget {
  final icon; // icon of the button
  final start; // function when tap

  final width;
  final height;

  ButtonJump({this.icon, this.start, this.width, this.height});

  @override
  _ButtonJumpState createState() => _ButtonJumpState();
}

class _ButtonJumpState extends State<ButtonJump> {
  final double _minVelocity = 3.5;
  final double _maxVelocity = 5.5;
  final Stopwatch sw = new Stopwatch();

  /// The height of the jump will vary with the intensity of the tap:
  ///  If one taps quickly, it will not jump high;
  ///  If one taps for a certain time (0.3s e.g.), it will jump higher.
  ///
  Widget build(BuildContext context) {
    return GestureDetector(
      // The clock starts as soon as one touches the button
      onTapDown: (details) {
        if (!sw.isRunning) {
          setState(() {
            sw.start();
          });
        }
      },
      /* When no more contact, jump with a velocity that depends on the
          elapsed time of the contact.
       */
      onTapUp: (details) {
        if (sw.isRunning) {
          double velocity =
              min(sw.elapsedMilliseconds / 200 + _minVelocity, _maxVelocity);
          widget.start(velocity);
          setState(() {
            sw.stop();
            sw.reset();
          });
        }
      },
      // When we leave the button, we jump
      onScaleStart: (details) {
        if (sw.isRunning) {
          double velocity =
              min(sw.elapsedMilliseconds / 200 + _minVelocity, _maxVelocity);
          widget.start(velocity);
          setState(() {
            sw.stop();
            sw.reset();
          });
        }
      },
      /* To avoid high velocities, once the contact is considered a
          "long press" (400ms), jump with the max velocity
       */
      onLongPressStart: (details) {
        if (sw.isRunning) {
          double velocity =
              min(sw.elapsedMilliseconds / 200 + _minVelocity, _maxVelocity);
          widget.start(velocity);
          setState(() {
            sw.stop();
            sw.reset();
          });
        }
      },

      child: ClipRRect(
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: sw.isRunning ? BUTTON_PRESSED : BUTTON_COLOR,
          ),
          padding: EdgeInsets.all(10),
          child: widget.icon,
        ),
      ),
    );
  }
}
