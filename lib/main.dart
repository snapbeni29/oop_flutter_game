import 'package:flutter/material.dart';
import 'package:flutter_app_mario/homePage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_mario/player.dart';
import 'package:flutter_app_mario/projectile.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<Player>(
        create: (context) => Player(),
        child: ChangeNotifierProvider<Projectile>(
          create: (context) => Projectile(projectileX: 0, projectileY: 0.9, direction: "right"),
          child: HomePage(),
        ),
      ),
    );
  }
}
