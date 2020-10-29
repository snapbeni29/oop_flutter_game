import 'package:flutter/material.dart';
import 'package:flutter_app_mario/Body.dart';
import 'package:flutter_app_mario/Platform/Platform.dart';

class Layout{
  List<Platform> create(BuildContext context){
    List<Platform> platformList = new List();

    platformList.add(Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: 1.0,
        y: 1.0,
      ),
    ));

    /*
    platformList.add(Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: 1.0,
        y: -1.0,
      ),
    ));
    */

    platformList.add(Platform(
      body: new Body(
        width: MediaQuery.of(context).size.width / 4.0,
        height: (MediaQuery.of(context).size.height * 5.0 / 7.0) / 4.0,
        x: -1.0,
        y: -0.5,
      ),
    ));

    return platformList;
  }
}