import 'package:corona_bot/pages/PreGamePage.dart';
import 'package:corona_bot/pages/ShopPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:corona_bot/pages/HomePage.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: "Cs"),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/game': (context) => PreGamePage(),
        '/shop': (context) => ShopPage(),
      },
    );
  }
}
