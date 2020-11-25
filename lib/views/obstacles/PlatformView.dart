import 'package:corona_bot/Body.dart';
import 'package:flutter/material.dart';

class PlatformView {
  Widget displayPlatform(Body body) {
    return AnimatedContainer(
      alignment: Alignment(body.x, body.y),
      duration: Duration(milliseconds: 0),
      child: Container(
        width: body.width,
        height: body.height,
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/Background/tile-1.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
