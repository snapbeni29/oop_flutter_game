import 'package:corona_bot/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  SharedPreferences prefs;
  int coins = 0;
  int projectiles = INIT_PROJECTILE;
  bool sombrero = false;
  bool doubleJump = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  /// Load the data in the variables
  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
      String hat = prefs.getString("hat") ?? '';
      sombrero = hat == '' ? false : true;
      doubleJump = prefs.getBool("Double Jump") ?? false;
      projectiles = prefs.getInt("projectiles") ?? INIT_PROJECTILE;
    });
  }

  /// Displays the number of coins
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
    // Widget representing the image used in the double jump item
    Widget doubleJumpDisplay = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Image.asset(
        "images/Player/Jump (5).png",
        height: MediaQuery.of(context).size.height / 6.7,
      ),
    );

    // Widget representing the image used in the +1 projectiles item
    Widget extendShootDisplay = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Image.asset(
            "images/Player/RunShoot (1).png",
            height: MediaQuery.of(context).size.height / 6.7,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Image.asset(
            "images/Objects/Bullet_004.png",
            height: MediaQuery.of(context).size.height / 35,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );

    // Widget representing the image used in the Sombrero item
    Widget sombreroDisplay = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Image.asset(
        "images/Accessories/sombrero.png",
        height: MediaQuery.of(context).size.height / 6.7,
      ),
    );

    return Scaffold(
      // AppBar ----------------------------------------------------------------
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: APPBAR_COLOR,
        // Go back button on the left ------------------------------------------
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/');
          },
        ),
        // title ---------------------------------------------------------------
        title: Text(
          "CoronaBot",
          style: TextStyle(fontFamily: "Cs"),
        ),
        // Coins on the right --------------------------------------------------
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
      // Body ------------------------------------------------------------------
      body: Container(
        // background image
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/Background/full-background.png"),
            fit: BoxFit.cover,
          ),
        ),
        // List of all the items -----------------------------------------------
        child: ListView(
          children: [
            // Start of Abilities part -----------------------------------------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Abilities",
                style: TextStyle(
                  fontSize: 40.0,
                  color: BORDER_COLOR,
                ),
              ),
            ),
            // Grid view of the Abilities items --------------------------------
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              // to disable GridView's scrolling
              shrinkWrap: true,
              childAspectRatio: 1,
              primary: false,
              padding:
              const EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                doubleJump == false
                    ? _shopItem(doubleJumpDisplay, "Double Jump", "20")
                    : _acquiredItem(doubleJumpDisplay, "Double Jump", "20"),
                projectiles < 6
                    ? _shopItem(extendShootDisplay, "+1 Projectile", "20")
                    : _acquiredItem(extendShootDisplay, "+1 Projectile", "20"),
              ],
            ),
            // Start of Accessories part ---------------------------------------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Accessories",
                style: TextStyle(
                  fontSize: 40.0,
                  color: BORDER_COLOR,
                ),
              ),
            ),
            // Grid view of the Accessories items ------------------------------
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              // to disable GridView's scrolling
              shrinkWrap: true,
              childAspectRatio: 1,
              primary: false,
              padding:
              const EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                sombrero == false
                    ? _shopItem(sombreroDisplay, "The Sombrero", "15")
                    : _acquiredItem(sombreroDisplay, "The Sombrero", "15"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a shop item whit a gesture detector.
  ///
  /// You will be able to buy the item if you have enough.
  ///   -> In this case an alert dialog pop to confirm the purchase.
  /// If you don't have enough coins.
  ///   -> An alert dialog tells you that you don't have enough.
  Widget _shopItem(Widget img, String name, String cost) {
    return GestureDetector(
      onTap: () {
        return showDialog(
          context: context,
          builder: (_) {
            // if you have enough coins
            if (coins >= int.parse(cost)) {
              // Alert Dialog to confirm the purchase---------------------------
              return AlertDialog(
                // title -------------------------------------------------------
                title: Center(child: Text("You are going to buy")),
                backgroundColor: Colors.blueAccent,
                // content -----------------------------------------------------
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Shop icon without gesture detector ----------------------
                    _shopIcon(img, name, cost),
                    // Button Go back and Confirm ------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          elevation: 2.0,
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Go Back",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          color: BUTTON_COLOR,
                        ),
                        RaisedButton(
                          elevation: 2.0,
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          onPressed: () {
                            switch (name) {
                              case "Double Jump":
                                prefs.setBool(name, true);
                                doubleJump = true;
                                break;
                              case "+1 Projectile":
                                projectiles += 1;
                                prefs.setInt("projectiles", projectiles);
                                break;
                              case "The Sombrero":
                                prefs.setString("hat", "Mex");
                                sombrero = true;
                                break;
                              default:
                                break;
                            }
                            coins = coins - int.parse(cost);
                            prefs.setInt("coins", coins);

                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          color: BUTTON_COLOR,
                        ),
                      ],
                    ),
                  ],
                ),
                elevation: 10.0,
              );
            } else {
              // Alert Dialog if you don't have enough -------------------------
              return AlertDialog(
                title: Center(child: Text("You don't have enough coins")),
                elevation: 10.0,
                backgroundColor: Colors.blueAccent,
                content: RaisedButton(
                  elevation: 2.0,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Go Back",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  color: BUTTON_COLOR,
                ),
              );
            }
          },
        );
      },
      // Container that hold the item ------------------------------------------
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: BORDER_COLOR,
            width: 8,
          ),
        ),
        // Column with the cost, the name, and the item ------------------------
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
                    cost,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                name,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            img,
          ],
        ),
      ),
    );
  }

  /// Displays shop item but without gesture detector
  Widget _shopIcon(Widget img, String name, String cost) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: BORDER_COLOR,
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
                  cost,
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          img,
        ],
      ),
    );
  }

  /// Displays of a shop item that has been purchased
  Widget _acquiredItem(Widget img, String name, String cost) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: BORDER_COLOR,
          width: 8,
        ),
      ),
      child: Stack(
        children: [
          Column(
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
                      cost,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              img,
            ],
          ),
          Container(
            // to fit parent widget with a dark overlay
            height: double.maxFinite,
            width: double.maxFinite,
            color: Color.fromRGBO(0, 0, 0, 0.25),
          ),
          Image.asset(
            'images/Background/acquired.png',
            color: Color.fromRGBO(124, 252, 0, 1),
          ),
        ],
      ),
    );
  }
}
