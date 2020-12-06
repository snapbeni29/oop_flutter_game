import 'package:flutter/material.dart';

enum Direction { UP, DOWN, STILL, RIGHT, LEFT, STILL_LEFT, STILL_RIGHT }

// Speed of objects
const double SPEED = 0.025;
const double PROJECTILE_SPEED = 0.03;
const double ENEMY_SPEED = 0.01;

// An obstacle is on screen if body.x > -onScreen && body.x < onScreen
const double onScreen = 1.2;

// Button colors
const Color BUTTON_COLOR = Colors.greenAccent;
const Color BUTTON_STUCK = Colors.grey;
const Color BUTTON_PRESSED = Colors.white;

const Color LIFE_COLOR = Color(0xff50c878);
const Color HURT_COLOR = Color(0xffde1738);
const Color BORDER_COLOR = Color(0xff34414e);

// AppBar color
const Color APPBAR_COLOR = Color(0xff10cfef);

// Player constants
const int INIT_PROJECTILE = 3;

// Level constants
const int NB_LEVELS = 5;
const double TIME_LEVEL = 200.5; // in seconds
const int BOSS_HEALTH = 20;
const int ENEMY_HEALTH = 3;
const int PLATFORM_HEALTH = 6;

// Collectable types
const String BLUE_POTION = "bluePot"; // freezing potion during potion 10s
const String RED_POTION = "redPot"; // infinite ammo during 5s
const String GREEN_POTION = "greenPot"; // heal potion
const String COIN = "coin";
const String END_FLAG = "end";

// List all the images used in this application
// use terminal command: find . -name *.png -print
// to get all paths
const List<String> imagePaths = [
  'images/Background/full-background.png',
  'images/Background/layer-1.png',
  'images/Background/layer-2.png',
  'images/Background/shop.png',
  'images/Background/tile_break.png',
  'images/Background/tile-1.png',
  'images/Background/acquired.png',
  'images/Background/tile_breakable.png',
  'images/Accessories/sombrero.png',
  'images/Objects/BulletBlue_004.png',
  'images/Objects/Bullet_004.png',
  'images/Objects/FlagPole.png',
  'images/Coins/Coin.png',
  'images/Potions/orangePot.png',
  'images/Potions/purplePot.png',
  'images/Potions/bluePot.png',
  'images/Potions/yellowPot.png',
  'images/Potions/redPot.png',
  'images/Potions/greenPot.png',
  'images/Monsters/virus8.png',
  'images/Monsters/virus4.png',
  'images/Monsters/virus5.png',
  'images/Monsters/virus7.png',
  'images/Monsters/virus6.png',
  'images/Monsters/virus2.png',
  'images/Monsters/virus3.png',
  'images/Monsters/virus1.png',
  'images/Player/RunShoot (7).png',
  'images/Player/Dead (1).png',
  'images/Player/Run (8).png',
  'images/Player/RunMexRed (7).png',
  'images/Player/RunRed (1).png',
  'images/Player/RunMexBlue (3).png',
  'images/Player/RunBlue (6).png',
  'images/Player/Run (4).png',
  'images/Player/Idle (1).png',
  'images/Player/RunMex (6).png',
  'images/Player/RunMex (7).png',
  'images/Player/Run (5).png',
  'images/Player/RunBlue (7).png',
  'images/Player/RunMexBlue (2).png',
  'images/Player/RunMexRed (6).png',
  'images/Player/RunShoot (6).png',
  'images/Player/RunMexRed (1).png',
  'images/Player/RunRed (7).png',
  'images/Player/JumpBlue (9).png',
  'images/Player/RunMexBlue (5).png',
  'images/Player/Run (2).png',
  'images/Player/JumpBlue (5).png',
  'images/Player/RunShoot (1).png',
  'images/Player/Dead (7).png',
  'images/Player/Dead (6).png',
  'images/Player/RunMexBlue (8).png',
  'images/Player/JumpMexRed (9).png',
  'images/Player/RunMex (1).png',
  'images/Player/Run (3).png',
  'images/Player/RunBlue (1).png',
  'images/Player/RunMexBlue (4).png',
  'images/Player/RunRed (6).png',
  'images/Player/JumpMexRed (5).png',
  'images/Player/RunMex (2).png',
  'images/Player/Dead (9).png',
  'images/Player/RunBlue (2).png',
  'images/Player/IdleMexBlue (1).png',
  'images/Player/RunMexBlue (7).png',
  'images/Player/RunRed (5).png',
  'images/Player/RunMexRed (3).png',
  'images/Player/JumpRed (5).png',
  'images/Player/IdleMexRed (1).png',
  'images/Player/Dead (5).png',
  'images/Player/RunShoot (3).png',
  'images/Player/JumpRed (9).png',
  'images/Player/IdleMex (1).png',
  'images/Player/JumpMexBlue (5).png',
  'images/Player/RunRed (8).png',
  'images/Player/RunShoot (2).png',
  'images/Player/Dead (4).png',
  'images/Player/RunMexRed (2).png',
  'images/Player/RunRed (4).png',
  'images/Player/JumpMexBlue (9).png',
  'images/Player/RunMexBlue (6).png',
  'images/Player/Dead (8).png',
  'images/Player/RunBlue (3).png',
  'images/Player/Run (1).png',
  'images/Player/RunMex (3).png',
  'images/Player/Jump (5).png',
  'images/Player/RunMex (8).png',
  'images/Player/Dead (3).png',
  'images/Player/RunBlue (8).png',
  'images/Player/RunShoot (5).png',
  'images/Player/RunMex (4).png',
  'images/Player/Jump (9).png',
  'images/Player/Run (6).png',
  'images/Player/RunBlue (4).png',
  'images/Player/RunShoot (9).png',
  'images/Player/IdleBlue (1).png',
  'images/Player/RunMexBlue (1).png',
  'images/Player/Dead (10).png',
  'images/Player/RunRed (3).png',
  'images/Player/RunMexRed (5).png',
  'images/Player/RunMexRed (4).png',
  'images/Player/RunRed (2).png',
  'images/Player/JumpMex (5).png',
  'images/Player/RunShoot (8).png',
  'images/Player/RunBlue (5).png',
  'images/Player/Run (7).png',
  'images/Player/RunMex (5).png',
  'images/Player/RunMexRed (8).png',
  'images/Player/RunShoot (4).png',
  'images/Player/JumpMex (9).png',
  'images/Player/Dead (2).png',
  'images/Player/IdleRed (1).png'
];
