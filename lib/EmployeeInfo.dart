import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'base_url.dart';

class Profile extends StatefulWidget {
  final String name, email, mobile, address, city, lastName, empid;
  final List role;
  Profile(
      {@required this.name,
      this.address,
      this.city,
      this.email,
      this.mobile,
      this.role,
      this.lastName,
      this.empid});
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<Profile>
    with SingleTickerProviderStateMixin {
  ProgressDialog pr;
  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobno = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool _checkBoxVal = false;
  bool _checkBoxVal1 = false;
  bool _checkBoxVal2 = false;
  String admin, measurer, installer;
  // Future<Album> futureAlbum;
  String name1, emai1, mob, img;
  bool _status = true;
  String token;
  var myData;
  final FocusNode myFocusNode = FocusNode();
  Map data;

  List userData;
  // String url = "http://env-alignpros.mircloud.us/api/user/profile";
  _showSnackBar(String snackbarData) {
    final snackbar = new SnackBar(
      content: new Text("$snackbarData"),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.red,
      //  action: new SnackBarAction(label: 'ok', onPressed: (){

      //  }),
    );

    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  void initState() {
    super.initState();
    print(widget.empid);
    name.text = widget.name;
    mobno.text = widget.mobile;
    email.text = widget.email;
    address.text = widget.address;
    city.text = widget.city;
    lastName.text = widget.lastName;
    _showImageDialog();
  }

  final _formKey = GlobalKey<FormState>();

  File _image;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Wait..',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return WillPopScope(
      onWillPop: () async => getPackageInfo(),
      child: Scaffold(
          backgroundColor: Colors.indigo[200],
          key: _scaffoldkey,
          appBar: AppBar(
            title: Text(
              "Profile",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.indigo[300],
            elevation: 2,
          ),
          body: new Container(
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: Form(
                          key: _formKey,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 20.0),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Personal Information',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _status
                                              ? _getEditIcon()
                                              : new Container(),
                                        ],
                                      )
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'First Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter Name';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: "Enter Your Name",
                                            filled: true,
                                          ),
                                          enabled: !_status,
                                          autofocus: !_status,
                                          controller: name,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Last Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please Enter Last Name';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: "Enter Your Last Name",
                                            filled: true,
                                          ),
                                          enabled: !_status,
                                          autofocus: !_status,
                                          controller: lastName,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Email ID',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter Email Id';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              filled: true,
                                              hintText: "Enter Email ID"),
                                          enabled: !_status,
                                          autofocus: !_status,
                                          controller: email,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Mobile',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter Mobile Number';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              filled: true,
                                              hintText: "Enter Mobile Number"),
                                          enabled: !_status,
                                          controller: mobno,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Address',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter Address';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              filled: true,
                                              hintText: "Enter Address "),
                                          enabled: !_status,
                                          controller: address,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'City',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter City name';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              filled: true,
                                              hintText: "Enter City"),
                                          enabled: !_status,
                                          controller: city,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Job Role',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.only(right: 20.0, top: 2.0),
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: this._checkBoxVal,
                                      activeColor: Colors.indigo[200],
                                      checkColor: Colors.white,

                                      // groupValue: "AD",
                                      // value: "AD",
                                      onChanged: (bool value) {
                                        setState(() {
                                          this._checkBoxVal = value;
                                          if (value == true) {
                                            measurer = "MEASURER";
                                            print(measurer);
                                          } else {
                                            measurer = "";
                                          }
                                          print(_checkBoxVal);
                                        });
                                      },
                                    ),
                                    Text("Measurer"),
                                    Spacer(),
                                    Checkbox(
                                      value: this._checkBoxVal1,
                                      autofocus: _status,
                                      activeColor: Colors.indigo[200],
                                      checkColor: Colors.white,
                                      // groupValue: "AD",
                                      // value: "BS",
                                      onChanged: (bool value) {
                                        setState(() {
                                          this._checkBoxVal1 = value;
                                          if (value == true) {
                                            installer = "INSTALLER";
                                            print(installer);
                                          } else {
                                            installer = "";
                                          }
                                        });
                                      },
                                    ),
                                    Text("Installer"),
                                    Spacer(),
                                    Checkbox(
                                      autofocus: _status,

                                      value: this._checkBoxVal2,
                                      activeColor: Colors.indigo[200],
                                      checkColor: Colors.white,
                                      // groupValue: "AD",
                                      // value: "BS",
                                      onChanged: (bool value) {
                                        setState(() {
                                          this._checkBoxVal2 = value;
                                          if (value == true) {
                                            admin = "Admin";
                                            print(admin);
                                          } else {
                                            admin = "";
                                          }
                                        });
                                      },
                                    ),
                                    Text("Admin"),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Password',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          obscureText: true,
                                          maxLines: 1,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter Password';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              filled: true,
                                              hintText: "Enter Password"),
                                          enabled: !_status,
                                          controller: pass,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Confirm Password',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          obscureText: true,
                                          maxLines: 1,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter Confirm Password';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              filled: true,
                                              hintText: "Confirm Password"),
                                          enabled: !_status,
                                          controller: confirmpass,
                                        ),
                                      ),
                                    ],
                                  )),
                              !_status ? _getActionButtons() : new Container(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    // myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.indigo[300],
                onPressed: () {
                  setState(() {
                    if (pass.text != null &&
                        confirmpass.text != null &&
                        pass.text == confirmpass.text) {
                      if (_formKey.currentState.validate()) {
                        addEmployee();
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }
                    } else {
                      _showSnackBar(
                          'Password and Confirm Password not matched');
                    }
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Color(0xff69737f),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.indigo[300],
        radius: 17.0,
        child: new Icon(
          FontAwesomeIcons.userEdit,
          color: Colors.white,
          size: 17.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Future<bool> getPackageInfo() async {
    Navigator.pop(context, false);
  }

  _showImageDialog() {
    for (var i in widget.role) {
      int id = i['id'];
      if (id == 1) {
        setState(() {
          _checkBoxVal2 = true;
          admin = 'ADMIN';
        });
      } else if (id == 3) {
        setState(() {
          _checkBoxVal1 = true;
          installer = 'INSTALLER';
        });
      } else if (id == 4) {
        setState(() {
          _checkBoxVal = true;
          measurer = 'MEASURER';
        });
      }
      // print(id);
    }
  }

  addEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    pr.show();
    Map data = {
      'id': widget.empid,
      'firstName': name.text,
      'lastName': lastName.text,
      'email': email.text,
      'mobileNumber': mobno.text,
      'address': address.text,
      'bio': '',
      'city': city.text,
      'roles': [measurer, admin, installer],
      'password': confirmpass.text,
    };
    String body = json.encode(data);

    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/register';
    http
        .post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 200) {
        pr.hide();
        Fluttertoast.showToast(
            msg: "Profile Updated..! ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context, true);
        //
        //  userData=loginData;
        setState(() {
          print(response.statusCode);
          //  print(userData[i]['name']);
        });
      } else {
        print(response.statusCode);
      }
    });
  }
}
