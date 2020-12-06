import 'package:corona_bot/Body.dart';
import 'package:corona_bot/constants.dart';
import 'package:flutter/material.dart';

/// View class of a platform.
class PlatformView {
  /// Displays a platform at its location.
  ///
  /// The texture of the platform is an image held in the "images/" folder.
  Widget displayPlatform(Body body, int health) {
    return AnimatedContainer(
      alignment: Alignment(body.x, body.y),
      duration: Duration(milliseconds: 0),
      child: Container(
        width: body.width,
        height: body.height,
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: health == -1
                ? new AssetImage("images/Background/tile-1.png")
                : health > PLATFORM_HEALTH/2
                    ? new AssetImage("images/Background/tile_breakable.png")
                    : new AssetImage("images/Background/tile_break.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
