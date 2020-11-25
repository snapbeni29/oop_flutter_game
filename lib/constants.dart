import 'package:flutter/material.dart';

enum Direction { UP, DOWN, STILL, RIGHT, LEFT, STILL_LEFT, STILL_RIGHT}

// Speed of objects
const double SPEED = 0.025;
const double PROJECTILE_SPEED = 0.03;
const double ENEMY_SPEED = 0.01;

// Button colors
const Color BUTTON_COLOR = Colors.greenAccent;
const Color BUTTON_STUCK = Colors.grey;
const Color BUTTON_PRESSED = Colors.white;

// Level constants
const int NB_LEVELS = 5;
const double TIME_LEVEL = 200.5; // in seconds

// Collectable types
const String BLUE_POTION = "bluePot"; // freezing potion during potion 10s
const String RED_POTION = "redPot"; // infinite ammo during 5s
const String GREEN_POTION = "greenPot"; // heal potion
const String COIN = "coin";
const String END_FLAG = "end";
