import 'package:aq_admin/SplashScreen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AQ Glass',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(),
    );
  }
}
