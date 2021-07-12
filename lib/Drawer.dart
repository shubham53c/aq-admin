import 'dart:convert';
import 'dart:io';
import 'package:aq_admin/Projects/archived_projects.dart';
import 'package:http/http.dart' as http;
import 'package:aq_admin/Calendar.dart';
import 'package:aq_admin/CreateProject.dart';
import 'package:aq_admin/EmployeeDetails.dart';
import 'package:aq_admin/Projects/Current_projects.dart';
import 'package:aq_admin/SplashScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_url.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String load;
  String img;
  String email;
  String firstName;
  String fname, lname, firstname;

  // Future appData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     fname = preferences.getString('name').toUpperCase();
  //     email = preferences.getString('email');
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // appData();
    // fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: <Widget>[
      // height: 50.0,
      DrawerHeader(
        child: Image.asset('lib/assets/AQglass.png'),
        margin: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: <Color>[
        //   Color(0xff44aae4), // shadowColor: Color(0xff225643),
        //   Color(0xff44aad5)
        // ])),
        // child: Container(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       Container(
        //         margin: EdgeInsets.only(right: 10, top: 18),
        //         child: SizedBox(
        //           width: 120.0,
        //           height: 50.0,
        //           child: DecoratedBox(
        //             decoration: const BoxDecoration(
        //               color: Colors.white,
        //             ),
        //             child: Image.asset('lib/assets/AQglass.png'),
        //           ),
        //         ),
        //       ),
        //       Padding(
        //           padding: EdgeInsets.all(8),
        //           child: Text(
        //             'Admin',
        //             style: TextStyle(color: Colors.white, fontSize: 20),
        //           )),
        //       // Padding(
        //       //     padding: EdgeInsets.only(
        //       //       left: 8,
        //       //       right: 8,
        //       //     ),
        //       //     child: Text(
        //       //       '$email',
        //       //       style: TextStyle(
        //       //           color: Colors.white,
        //       //           fontSize: 14,
        //       //           decoration: TextDecoration.underline),
        //       //     )),
        //     ],
        //   ),
        // ),
      ),

      ListTile(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.projectDiagram,
            color: Color(0xff44aae4),
          ),
          iconSize: 24,
          onPressed: () {},
        ),
        title: Text('Current Projects'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CurrentProjects()));
        },
      ),
      ListTile(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.fileArchive,
            color: Color(0xff44aae4),
          ),
          iconSize: 24,
          onPressed: () {},
        ),
        title: Text('Archive Projects'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ArchivedProjects()));
        },
      ),
      ListTile(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.calendarAlt),
          iconSize: 24,
          color: Color(0xff44aae4),
          onPressed: () {},
        ),
        title: Text('Calendar Events'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CalendarScreen()));
          // Fluttertoast.showToast(
          //     msg: "Under Development",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.black,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
        },
      ),
      // ListTile(
      //   leading: IconButton(
      //     icon: Icon(Icons.receipt),
      //     iconSize: 24,
      //     onPressed: () {},
      //   ),
      //   title: Text('Order History'),
      //   onTap: () {
      //     Navigator.pop(context);
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => OrderHistory()));
      //   },
      // ),
      Divider(height: 1, thickness: 0.5, color: Colors.blueGrey),
      ListTile(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.userAlt),
          iconSize: 24,
          color: Color(0xff44aae4),
          onPressed: () {},
        ),
        title: Text('Teams'),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeDetails()));
        },
      ),
      // ListTile(
      //   leading: IconButton(
      //     icon: Icon(FontAwesomeIcons.bookReader),
      //     iconSize: 24,
      //     onPressed: () {},
      //   ),
      //   title: Text('Magazine'),
      //   onTap: () {
      //     Navigator.pop(context);
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => PDFViewerPage()));
      //   },
      // ),

      // ),
      ListTile(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chrome),
          iconSize: 24,
          color: Color(0xff44aae4),
          onPressed: () {},
        ),
        title: Text('Visit Website'),
        onTap: () async {
          var url = 'https://aqglass.com/';

          // if (await canLaunch(url)) {
          //   launch(url);
          // } else {
          //   throw 'Could not launch $url';
          // }
        },
      ),
      ListTile(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.signOutAlt),
          iconSize: 24,
          color: Color(0xff44aae4),
          onPressed: () {},
        ),
        title: Text('Logout'),
        onTap: () async {
          //  final fcm=FirebaseMessaging();
          //  fcm.setAutoInitEnabled(false);
          //  fcm.deleteInstanceID();
          logOut();
        },
      ),

      Divider(height: 1, thickness: 0.5, color: Colors.blueGrey),
      SizedBox(
        height: 15,
      ),

      SizedBox(
        height: 15,
      )
    ]));
  }

  sendFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String firebaseToken = '';
    String url =
        '${ApiBaseUrl.BASE_URL}/restapi/user/saveFirebaseToken/$firebaseToken';
    await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('firebase $data');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext ctx) => AnimatedSplashScreen()));

// sendFirebaseToken(token);

      } else {
        // Navigator.pop(context);
        // print(response.statusCode);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext ctx) => AnimatedSplashScreen()));
      }
    });
  }

  void showLoadingSpinner() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              Text(' Please wait'),
            ],
          ),
        ),
      ),
    );
  }

  logOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text('Logout !'),
          content: Text('Are you sure you want to Logout ?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
// Navigator.pop(context, false);
                Navigator.of(
                  context,
// rootNavigator: true,
                ).pop(false);
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: () {
// Navigator.pop(context, true);
                setState(() {
// print(id);
// orders.removeAt(index);
                  Navigator.of(
                    context,
// rootNavigator: true,
                  ).pop(true);
                  showLoadingSpinner();
                  sendFirebaseToken();
                });
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
