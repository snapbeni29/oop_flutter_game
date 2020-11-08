import 'package:flutter/material.dart';
import 'package:flutter_app_mario/button/ButtonTemplate.dart';
import 'package:flutter_app_mario/button/ButtonType.dart';

class HomePage extends StatelessWidget {
  final int _numberOfLevels = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Name to find"),
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
              textAlign: TextAlign.center),
          ButtonTemplate(
            type: ButtonType.instant,
            icon: Icon(Icons.play_arrow),
            start: () => Navigator.pushNamed((context), '/game',
                arguments: levelNumber + 1),
          ),
        ],
      ),
    );
  }
}
