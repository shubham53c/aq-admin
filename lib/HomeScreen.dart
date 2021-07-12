// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:aq_admin/Install.dart';
import 'package:aq_admin/Measure.dart';
import 'package:aq_admin/Orders.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  int _selectedTab = 0;
  String _title;
  final _pageOptions = [Measure(), Orders(), Install()];

  @override
  void initState() {
    super.initState();
  }

  // Future<void> notificationAfterSec() async {
  //   var timeDelayed = DateTime.now().add(Duration(seconds: 5));
  //   AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //           'second channel ID', 'second Channel title', 'second channel body',
  //           priority: Priority.High,
  //           importance: Importance.Max,
  //           ticker: 'test');

  //   IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

  //   NotificationDetails notificationDetails =
  //       NotificationDetails(androidNotificationDetails, iosNotificationDetails);
  //   await flutterLocalNotificationsPlugin.schedule(1, 'Hello there',
  //       'please subscribe my channel', timeDelayed, notificationDetails);
  // }

  Future<void> onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      print(payLoad);
    }
  }

  Future<bool> _onBackPressed() {
    return _onback();
  }

  Future _onback() async {
    setState(() {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     _title,
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   actions: <Widget>[
      //     IconButton(icon: Icon(Icons.notifications), onPressed: () {})
      //   ],
      // ),
      // drawer: MainDrawer(),
      body: _pageOptions[_selectedTab],
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => Appointment(),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Color(0xff225643),
      //   foregroundColor: Colors.white,
      //   elevation: 2.0,
      // ),
      bottomNavigationBar: BottomAppBar(
        // shape: CircularNotchedRectangle(),
        // clipBehavior: Clip.antiAlias,
        // notchMargin: 4.0,
        child: SizedBox(
          height: 60,
          child: Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Color(0xffffffff),

                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Color(0xff44aae4),
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.white))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedTab,
              onTap: (int index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              unselectedItemColor: Color(0xff69737f),
              // fixedColor: Color(0xffFF5555),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.assignment), title: Text('Measure')),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.tasks), title: Text('Orders')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.business_center), title: Text('Install')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
