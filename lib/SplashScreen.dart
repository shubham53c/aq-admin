import 'dart:async';
import 'package:aq_admin/HomeScreen.dart';
import 'package:aq_admin/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  bool val = false;
  navigationPage() {
    val
        ? Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext ctx) => HomeScreen()))
        : Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext ctx) => SignupOnePage()));
  }

  @override
  void initState() {
    super.initState();
    checkIsLogin();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }
  @override
dispose() {
  animationController.dispose(); // you need this
  super.dispose();
}

  Future<Null> checkIsLogin() async {
    String _token = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = prefs.getString("token");
    if (_token != "" && _token != null) {
      setState(() {
        val = true;
      });
      print("splash login.");
      //your home page is loaded
    } else {
      print('splash logout');
      val = false;
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => new FirstPage()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Padding(padding: EdgeInsets.only(bottom: 30.0),child:new Image.asset('lib/assets/blankprofile.png',height: 50.0,fit: BoxFit.scaleDown,))
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  'lib/assets/AQglass.png',
                  width: animation.value * 250,
                  height: animation.value * 250,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
