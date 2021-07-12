import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:aq_admin/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_url.dart';

class SignupOnePage extends StatefulWidget {
  @override
  _SignupOnePageState createState() => _SignupOnePageState();
}

class _SignupOnePageState extends State<SignupOnePage> {
  String token = 'token';
  bool val = false;
  var loginData;
  Future<bool> saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(token, loginData['token']);
  }

  @override
  initState() {
    super.initState();
    print('badsbvkjsdkj $generateDeviceTokenForFirebase');
  }

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackbar = new SnackBar(
      content: new Text("Invalid Email or Password"),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.blue,
      //  action: new SnackBarAction(label: 'ok', onPressed: (){

      //  }),
    );

    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  Widget _buildPageContent(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade100,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Container(
              margin: EdgeInsets.only(right: 10, top: 18),
              child: SizedBox(
                width: 120.0,
                height: 50.0,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset('lib/assets/AQglass.png'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "(Admin)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // CircleAvatar(child: PNetworkImage(origami), maxRadius: 50, backgroundColor: Colors.transparent,),
            SizedBox(
              height: 20.0,
            ),
            _buildLoginForm(context),
          ],
        ),
      ),
    );
  }

  Container _buildLoginForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 350,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        style: TextStyle(color: Colors.blue),
                        controller: _email,
                        decoration: InputDecoration(
                            hintText: "Email address",
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        style: TextStyle(color: Colors.blue),
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.blue.shade200),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.blue,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade600,
                child: Icon(Icons.person),
              ),
            ],
          ),
          Container(
            height: 370,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: val
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: () {
                          setState(() {
                            val = true;
                          });
                          addData(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Text("Login",
                            style: TextStyle(color: Colors.white70)),
                        color: Colors.blue,
                      )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: _buildPageContent(context),
    );
  }
  // Future<void> notifyParent(String alertMessage) async {

  //   final res = await http.post(
  //     'https://rideassure.us/restapi/child/emergencymessage',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json;charset=UTF-8',
  //       'Charset': 'utf-8',
  //     },
  //     body: jsonEncode({
  //       "from": "$childId",
  //       "to": "$parentId",
  //       "title": "RideAssure Alert",
  //       "message": "$childName $alertMessage"
  //     }),
  //   );
  //   final responseData = json.decode(res.body);
  //   print('notification sent through notifyParent $responseData');
  // }
  Future<String> get generateDeviceTokenForFirebase async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String deviceId = await _firebaseMessaging.getToken();
    print('deviceId $deviceId');
    return deviceId;
  }

  Future getData(String token) async {
    http.Response response = await http.get(
        '${ApiBaseUrl.BASE_URL}/restapi/user/profile',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      String firebaseToken = await generateDeviceTokenForFirebase;
      sendFirebaseToken(token, firebaseToken);
    } else {
      print(response.statusCode);
    }
  }

  sendFirebaseToken(String token, firebaseToken) {
    String url =
        '${ApiBaseUrl.BASE_URL}/restapi/user/saveFirebaseToken/$firebaseToken';
    http.post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('firebase $data');
        //  sendFirebaseToken(token);
      } else {
        print(response.statusCode);
      }
    });
  }

  addData(BuildContext context) {
    Map data = {
      'email': _email.text,
      'password': _password.text,
    };
    String body = json.encode(data);
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin-login';
    http
        .post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 200) {
        loginData = json.decode(response.body);
        print(loginData['token']);
        String token = loginData['token'];
        print('$token');
        getData(token);
        saveData();

        setState(() {
          val = false;
        });
        //  sendFirebaseToken(token);

        Navigator.pop(context, true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        print('dfdf ${response.body}');
        print(response.statusCode);
        setState(() {
          val = false;
        });
        _showSnackBar();
      }
    });
  }
}
