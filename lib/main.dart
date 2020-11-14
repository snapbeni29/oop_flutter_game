import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_mario/views/HomePage.dart';
import 'package:flutter_app_mario/views/PreGamePage.dart';

void main() {
  runApp(MyApp());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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
      },
    );
  }
}
