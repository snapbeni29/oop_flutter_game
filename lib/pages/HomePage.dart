import 'package:corona_bot/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///  The home page consists in a list of levels to play.
///  Each level button is represented by a widget _LevelWidget.
///    Such a widget is a box that contains the number of the level,
///    the highest score on this level and a button to start this level.
///    When one presses the button, the page PreGamePage starts
///   (route '/game'). The number of the level is an argument that
///   can be used in PreGamePage.
///
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int coins;
  List<String> scoreLevel;
  bool doubleJump;
  String hat;
  int projectiles;

  @override
  void initState() {
    super.initState();
    getData();
  }

  /// Load the data in the variables
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
      scoreLevel = prefs.getStringList('scoreLevel');
      hat = prefs.getString('hat') ?? '';
      doubleJump = prefs.getBool("Double Jump") ?? false;
      projectiles = prefs.getInt("projectiles") ?? INIT_PROJECTILE;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar ----------------------------------------------------------------
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: APPBAR_COLOR,
        title: Text(
          "CoronaBot",
          style: TextStyle(fontFamily: "Cs"),
        ),
        // Shop button on the left ---------------------------------------------
        leading: IconButton(
          tooltip: "Shop",
          icon: Image.asset('images/Background/shop.png'),
          onPressed: () {
            Navigator.of(context).pushNamed('/shop');
          },
        ),
        // Show coins on the right ---------------------------------------------
        actions: <Widget>[
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10.0, top: 4.0, bottom: 4.0),
              child: Image.asset('images/Coins/Coin.png'),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: Text(
                "$coins",
                style: TextStyle(
                  fontFamily: "Cs",
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
      // Body ------------------------------------------------------------------
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
                        return _LevelWidget(
                            index, doubleJump, hat, projectiles, false);
                      if (index < scoreLevel.length)
                        return _LevelWidget(
                          index,
                          doubleJump,
                          hat,
                          projectiles,
                          false,
                          score: double.parse(scoreLevel[index].split(":")[1]),
                        );
                      return _LevelWidget(
                          index, doubleJump, hat, projectiles, true);
                    } else {
                      return _LevelWidget(
                          index, doubleJump, hat, projectiles, true);
                    }
                  } else {
                    if (scoreLevel == null) {
                      return _LevelWidget(
                          index, doubleJump, hat, projectiles, false);
                    } else {
                      return _LevelWidget(
                        index,
                        doubleJump,
                        hat,
                        projectiles,
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
  final String hat;
  final bool doubleJump;
  final int projectiles;

  final double score;

  _LevelWidget(this.levelNumber, this.doubleJump, this.hat, this.projectiles,
      this.locked, {this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        border: Border.all(
          color: BORDER_COLOR,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Number of the level
          Text(
            'Level ' + (levelNumber + 1).toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          // Highest score if it exists
          score == null
              ? SizedBox()
              : Text(
                  'Highest Score ' + score.toStringAsFixed(0),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
          // Button to start the level
          // Can be locked or not
          RaisedButton(
            onPressed: () {
              // args[0] is lvl number
              // args[1] is the hat
              // args[2] is the doubleJump
              // args[3] number of projectiles
              List<dynamic> args = <dynamic>[];
              args.add(levelNumber + 1);
              args.add(hat);
              args.add(doubleJump);
              args.add(projectiles);
              if (!locked) {
                Navigator.pushNamed((context), '/game', arguments: args);
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
