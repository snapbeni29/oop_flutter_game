import 'dart:async';

import 'package:corona_bot/constants.dart';
import 'package:corona_bot/controllers/LevelController.dart';
import 'package:corona_bot/controllers/PlayerController.dart';
import 'package:corona_bot/pages/GamePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Intermediary class useful for declaring the provider,
/// retrieving the number of the level to play
/// and starting the loading page.
class PreGamePage extends StatelessWidget {
  final levelCreated = 1;

  @override
  Widget build(BuildContext context) {
    List<dynamic> args = ModalRoute.of(context).settings.arguments;
    final int levelNumber = args[0];
    final String hat = args[1];
    final bool doubleJump = args[2];
    final int projectiles = args[3];

    // If the level is not created yet, we display a screen
    if (levelNumber > levelCreated || levelNumber < 1) {
      return Container(
        child: RaisedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("This level does not exist yet!"),
          color: BUTTON_COLOR,
        ),
      );
    }

    // otherwise,  start the game on the GamePage
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LevelController>(
          create: (_) => LevelController(
              new PlayerController(context, hat, doubleJump, projectiles),
              context,
              levelNumber),
        ),
      ],
      child: _LoadingPage(),
    );
  }
}

class _LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<_LoadingPage> {
  Future<bool> _loadImages() {
    return Future<bool>.delayed(
      Duration(seconds: 4),
      () => true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadImages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GamePage();
        }
        List<Widget> list = new List();
        list.add(
          Column(
            children: [
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                // Container of 5/7 of screen on the top -----------------------
                child: Container(
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("images/Background/layer-1.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  // On the container we place a loading bar + the robot -------
                  child: Stack(
                    children: [
                      // Text Loading ------------------------------------------
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        alignment: Alignment(0, -0.9),
                        child: Text(
                          "Loading",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 40.0,
                            fontFamily: "Cs",
                            color: Color(0xff34414e),
                          ),
                        ),
                      ),
                      // Loading bar with rounded border -----------------------
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: MediaQuery.of(context).size.width / 5),
                        alignment: Alignment(0, -0.7),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: LinearProgressIndicator(
                            minHeight: MediaQuery.of(context).size.height / 20,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.greenAccent,
                            ),
                            backgroundColor: Color(0xff34414e),
                          ),
                        ),
                      ),
                      // Gif of robot running ----------------------------------
                      Container(
                        alignment: Alignment(0, 1),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 14.0,
                          height:
                              (MediaQuery.of(context).size.height * 5.0 / 7.0) /
                                  5,
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage(
                                  "images/Player/loadingGif.gif"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom of screen with the ground ------------------------------
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("images/Background/layer-2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        // Load images and display them out of screen
        for (var name in imagePaths) {
          list.add(
            Container(
              alignment: Alignment(0, -3),
              child: Image.asset(
                name,
                color: Color.fromRGBO(0, 0, 0, 0.0),
              ),
            ),
          );
        }
        return Stack(
          children: list,
        );
      },
    );
  }
}
