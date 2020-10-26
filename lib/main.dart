import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_mario/Platform/Level.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_mario/Player.dart';
import 'package:flutter_app_mario/HomePage.dart';

void main() {

  Player player = Player();
  Level level = Level(player);

  runApp(
    ChangeNotifierProvider(
        create: (context) => player,
        child: ChangeNotifierProvider(
          create: (context) => level,
          child: MyApp(),
        )),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
