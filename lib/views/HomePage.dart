import 'package:flutter/material.dart';
import 'package:flutter_app_mario/button/ButtonTemplate.dart';
import 'package:flutter_app_mario/button/ButtonType.dart';

/*
  The home page consists in a list of levels to play.
  Each level button is represented by a widget _LevelWidget.
    Such a widget is a box that contains the number of the level
    and a button to start this level.
    When one presses the button, the page PreGamePage starts
    (route '/game'). The number of the level is an argument that
    can be used in PreGamePage.
 */

class HomePage extends StatelessWidget {
  final int _numberOfLevels = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CoronaBot",
          style: TextStyle(fontFamily: "Cs"),
        ),
      ),
      body: new ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _numberOfLevels,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: new _LevelWidget(index),
          );
        },
      ),
    );
  }
}

class _LevelWidget extends StatelessWidget {
  final int levelNumber;

  _LevelWidget(this.levelNumber);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Level ' + (levelNumber + 1).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              )),
          ButtonTemplate(
            type: ButtonType.instant,
            icon: Icon(Icons.play_arrow),
            start: (_) => Navigator.pushNamed((context), '/game',
                arguments: levelNumber + 1),
          ),
        ],
      ),
    );
  }
}
