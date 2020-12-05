import 'package:corona_bot/Body.dart';
import 'package:flutter/material.dart';

/// View class of a platform.
class PlatformView {

  /// Displays a platform at its location.
  ///
  /// The skin of the platform is an image held in the "images/" folder.
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
