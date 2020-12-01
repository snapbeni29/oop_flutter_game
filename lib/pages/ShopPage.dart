import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int coins;

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Load the number of coins in the "coins" variable
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
    });
  }

  Widget displayCoins() {
    return Padding(
      padding: const EdgeInsets.only(right: 100.0),
      child: Text(
        "$coins",
        style: TextStyle(
          fontFamily: "Cs",
          fontSize: 20.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "CoronaBot",
          style: TextStyle(fontFamily: "Cs"),
        ),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 10.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Image.asset('images/Coins/Coin.png'),
            ),
          ),
          Center(
            child: displayCoins(),
          ),
        ],
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/Background/full-background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Abilities",
                style: TextStyle(
                  fontSize: 40.0,
                  color: Color(0xffd2691e),
                ),
              ),
            ),
            GridView.count(
              physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true, // You won't see infinite size error
              childAspectRatio: 1,
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Color(0xffd2691e),
                      width: 8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Image.asset(
                                'images/Coins/Coin.png',
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                            Text(
                              "20",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Double Jump",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Image.asset(
                          "images/Player/Jump (5).png",
                          height: MediaQuery.of(context).size.height / 6.7,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Color(0xffd2691e),
                      width: 8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Image.asset(
                                'images/Coins/Coin.png',
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                            Text(
                              "20",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "+ 1 Projectile",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 4.0),
                            child: Image.asset(
                              "images/Player/RunShoot (1).png",
                              height: MediaQuery.of(context).size.height / 6.7,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 4.0),
                            child: Image.asset(
                              "images/Objects/Bullet_004.png",
                              height: MediaQuery.of(context).size.height / 35,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Accessories",
                style: TextStyle(
                  fontSize: 40.0,
                  color: Color(0xffd2691e),
                ),
              ),
            ),
            GridView.count(
              physics: NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true, // You won't see infinite size error
              childAspectRatio: 1,
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Color(0xffd2691e),
                      width: 8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Image.asset(
                                'images/Coins/Coin.png',
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                            Text(
                              "20",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "The Sombrero",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Image.asset(
                          "images/Accessories/sombrero.png",
                          height: MediaQuery.of(context).size.height / 6.7,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
