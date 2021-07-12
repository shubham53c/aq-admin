import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'base_url.dart';

class Employees extends StatefulWidget {
  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  bool _checkBoxVal = false;
  bool _checkBoxVal1 = false;
  bool _checkBoxVal2 = false;
  String admin, measurer, installer;
  ProgressDialog pr;
  final TextEditingController firstname = new TextEditingController();
  final TextEditingController lastname = new TextEditingController();
  final TextEditingController mobileNumber = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController address = new TextEditingController();
  final TextEditingController city = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  final TextEditingController confirmpass = new TextEditingController();
  final TextEditingController bio = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

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
          key: _scaffoldkey,
          backgroundColor: Colors.indigo[300],
          body: Container(
            margin: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0), color: Colors.white),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Create New Team",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "First Name",
                    ),
                    TextFormField(
                      controller: firstname,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Last Name",
                    ),
                    TextFormField(
                      controller: lastname,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid name';
                        }
                        return null;
                      },
                    ),
                    // TextField(
                    //   controller: fullname,
                    // ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Mobile Number",
                    ),
                    TextFormField(
                      controller: mobileNumber,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid Mobile No';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Email ",
                    ),
                    TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid Email';
                        }
                        return null;
                      },
                    ),
                    // TextField(
                    //   controller: email,
                    // ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Address",
                    ),
                    TextFormField(
                      controller: address,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid Address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "City",
                    ),
                    TextFormField(
                      controller: city,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid City Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Job Role",
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: this._checkBoxVal,
                          activeColor: Colors.indigo[300],
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
                          activeColor: Colors.indigo[300],
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
                          value: this._checkBoxVal2,
                          activeColor: Colors.indigo[300],
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
                    const SizedBox(height: 20.0),
                    Text(
                      "Employee",
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          //value: true,
                          activeColor: Colors.indigo[300],
                          groupValue: "Male",
                          value: "Male",
                          onChanged: (value) {},
                        ),
                        Text("Verified"),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Password *",
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: password,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Confirm Password",
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: confirmpass,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.indigo[300],
                          textColor: Colors.white,
                          child: Text("Create".toUpperCase()),
                          onPressed: () {
                            setState(() {
                              print("1");
                              if (password.text == confirmpass.text &&
                                  password.text != null &&
                                  password.text != null) {
                                print("object");
                                if (_formKey.currentState.validate()) {
                                  addEmployee();
                                  // If the form is valid, display a Snackbar.
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Validation Success..!')));
                                }
                              } else {
                                print("failed");
                                _showSnackBar(
                                    'Password and Confirm Password not matched');
                              }
                              // if (_formKey.currentState.validate()) {
                              //   //addEmployee();
                              //   // If the form is valid, display a Snackbar.
                              //   Scaffold.of(context).showSnackBar(SnackBar(
                              //       content: Text('Validation Success!')));
                              // }
                            });
                          },
                        )),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // TextField _buildTextField({bool obscureText = false}) {
  //   return TextField(
  //     obscureText: obscureText,
  //   );
  // }
  Future<bool> getPackageInfo() async {
    Navigator.pop(context, false);
  }

  addEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    pr.show();

    Map data = {
      'firstName': firstname.text,
      'lastName': lastname.text,
      'email': email.text,
      'mobileNumber': mobileNumber.text,
      'address': address.text,
      'bio': '',
      'city': city.text,
      'id': '',
      'roles': [measurer, admin, installer],
      'password': confirmpass.text,
    };
    String body = json.encode(data);

    //prefs.getString("token");
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
        Fluttertoast.showToast(
            msg: "successfully Created..! ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        pr.hide();

        Navigator.pop(context, true);

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
