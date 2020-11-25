import 'package:corona_bot/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  The home page consists in a list of levels to play.
  Each level button is represented by a widget _LevelWidget.
    Such a widget is a box that contains the number of the level
    and a button to start this level.
    When one presses the button, the page PreGamePage starts
    (route '/game'). The number of the level is an argument that
    can be used in PreGamePage.
 */

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int coins;
  List<String> scoreLevel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
      scoreLevel = prefs.getStringList('scoreLevel');
    });
  }

  displayCoins() {
    return Padding(
      padding: const EdgeInsets.only(right: 100.0),
      child: Text(
        "$coins",
        style: TextStyle(
          fontFamily: "Cs",
          fontSize: 20.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CoronaBot",
          style: TextStyle(fontFamily: "Cs"),
        ),
        leading: IconButton(
          tooltip: "Shop",
          icon: Image.asset(
            'images/Background/shop.png',
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/shop');
          },
        ),
        actions: <Widget>[
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10.0, top: 4.0, bottom: 4.0),
              child: Image.asset('images/Coins/Coin.png'),
            ),
          ),
          Center(
            child: displayCoins(),
          ),
        ],
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/Background/full-background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: NB_LEVELS,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Builder(
                builder: (_) {
                  if (index > 0) {
                    if (scoreLevel != null) {
                      if (index == scoreLevel.length)
                        return _LevelWidget(index, false);
                      if (index < scoreLevel.length)
                        return _LevelWidget(
                          index,
                          false,
                          score: double.parse(scoreLevel[index].split(":")[1]),
                        );
                      return _LevelWidget(index, true);
                    } else {
                      return _LevelWidget(index, true);
                    }
                  } else {
                    if (scoreLevel == null) {
                      return _LevelWidget(index, false);
                    } else {
                      return _LevelWidget(
                        index,
                        false,
                        score: double.parse(scoreLevel[index].split(":")[1]),
                      );
                    }
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LevelWidget extends StatelessWidget {
  final int levelNumber;
  final bool locked;

  final double score;

  _LevelWidget(this.levelNumber, this.locked, {this.score});

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
          Text(
            'Level ' + (levelNumber + 1).toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          score == null
              ? SizedBox()
              : Text(
                  'Highest Score ' + score.toStringAsFixed(0),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
          RaisedButton(
            onPressed: () {
              if (!locked) {
                Navigator.pushNamed((context), '/game',
                    arguments: levelNumber + 1);
              }
            },
            child: locked ? Icon(Icons.lock_outline) : Icon(Icons.play_arrow),
            color: locked ? BUTTON_STUCK : BUTTON_COLOR,
          ),
        ],
      ),
    );
  }
}