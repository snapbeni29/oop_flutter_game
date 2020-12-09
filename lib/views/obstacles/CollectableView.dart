import 'package:corona_bot/Body.dart';
import 'package:corona_bot/constants.dart';
import 'package:flutter/material.dart';

/// View class of a collectable
class CollectableView {
  /// Displays a collectable at its location.
  Widget displayCollectable(Body body, String type) {
    Image img;
    if (type == COIN) {
      img = Image.asset('images/Coins/Coin.png');
    } else if (type == END_FLAG) {
      img = Image.asset('images/Objects/FlagPole.png');
    } else {
      img = Image.asset('images/Potions/' + type + '.png');
    }

    return AnimatedContainer(
      alignment: Alignment(body.x, body.y),
      duration: Duration(milliseconds: 0),
      child: Container(
        width: body.width,
        height: body.height,
        child: FittedBox(
          fit: BoxFit.fill,
          child: img,
        ),
      ),
    );
  }
}
