import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/HomePage.dart';

void main() {
  runApp(MyApp());

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
