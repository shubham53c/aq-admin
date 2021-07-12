import 'dart:async';
import 'package:aq_admin/EmployeeInfo.dart';
import 'package:aq_admin/Employees.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_url.dart';

class EmployeeDetails extends StatefulWidget {
  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  List data1;
  Map data;
  void initState() {
    super.initState();
    // this.getPopularHomes();
    // this.checkStatus();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Teams",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo[300],
        elevation: 2,

        // actions: <Widget>[
        //   Padding(
        //     padding:
        //         const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        //     child: CircleAvatar(
        //       maxRadius: 15.0,
        //       // backgroundImage: NetworkImage(avatars[0]),
        //     ),
        //   )
        // ],
      ),
      body: data1 == null || data1.length == 0
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.indigo[300],
            ))
          : ListView.builder(
              shrinkWrap: true,

              // scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                // print(data1[index]['roles']);
                //  List roles = data1[index]['roles'];
                // print(roles.join(','));
                // var m = data1[index]['roles'][1]['name'];
                // var i = data1[index]['roles'][2]['name'];
                // var u = data1[index]['roles'][1]['name'];
                // var a = data1[index]['roles'][2]['name'];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("lib/assets/employee.png"),
                    ),
                    title: Text(data1[index]['firstName']),
                    subtitle: Text(data1[index]['email']),
                    trailing: Icon(
                      FontAwesomeIcons.edit,
                      color: Colors.indigo[300],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            new MaterialPageRoute(
                              builder: (_) => Profile(
                                name: data1[index]['firstName'],
                                address: data1[index]['address'],
                                city: data1[index]['city'],
                                email: data1[index]['email'],
                                mobile: data1[index]['mobileNumber'],
                                role: data1[index]['roles'],
                                lastName: data1[index]['lastName'],
                                empid: data1[index]['id'],
                              ),
                            ),
                          )
                          .then((val) => val ? _getRequests() : null);
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            title: Text('Are you sure ?'),
                            content: Text(
                                'Once deleted, you will not be able to recover this user !'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  // Navigator.pop(context, false);
                                  Navigator.of(
                                    context,
                                    // rootNavigator: true,
                                  ).pop(false);
                                },
                                child: Text('No',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              FlatButton(
                                onPressed: () {
                                  // Navigator.pop(context, true);
                                  setState(() {
                                    deleteProject(data1[index]['id'],
                                        data1[index]['firstName']);

                                    Navigator.of(
                                      context,
                                      // rootNavigator: true,
                                    ).pop(true);
                                  });
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
              itemCount: data1 == null ? 0 : data1.length),
      // ),
      // Divider(
      //   height: 1.0,
      //   indent: 1.0,
      //   color: Colors.indigo[300],
      // ),
      // Card(
      //   borderOnForeground: true,
      //   child: ListTile(
      //     leading: CircleAvatar(
      //       backgroundColor: Colors.white,
      //       backgroundImage: AssetImage("lib/assets/employee.png"),
      //     ),
      //     title: Text('James Smith'),
      //     subtitle: Text("Measurer | Installer"),
      //     trailing: Icon(
      //       FontAwesomeIcons.edit,
      //       color: Colors.indigo[300],
      //     ),
      //     onTap: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => Profile(
      //             name: 'James Smith',
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
      // Divider(
      //   height: 1.0,
      //   indent: 1.0,
      //   color: Colors.indigo[300],
      // ),
      // Card(
      //   child: ListTile(
      //     leading: CircleAvatar(
      //       backgroundColor: Colors.white,
      //       backgroundImage: AssetImage("lib/assets/employee.png"),
      //     ),
      //     title: Text('Anthony Johnson'),
      //     subtitle: Text("Measurer | Installer"),
      //     trailing: Icon(
      //       FontAwesomeIcons.edit,
      //       color: Colors.indigo[300],
      //     ),
      //     onTap: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => Profile(
      //             name: 'Anthony Johnson',
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                new MaterialPageRoute(builder: (_) => Employees()),
              )
              .then((val) => val ? _getRequests() : false);
        },
        child: Icon(FontAwesomeIcons.plus),
        backgroundColor: Colors.indigo[300],
      ),
    );
  }

  _getRequests() async {
    getData();
  }

  deleteProject(String id, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/deleteuser/$id';
    http.delete(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // Map<String, dynamic> loginData = json.decode(response.body);
        //  userData=loginData;
        setState(() {
          print(response.statusCode);
          getData();
          Fluttertoast.showToast(
              msg: "Deleted User Name :$name",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          //  print(userData[i]['name']);
        });
      } else {
        print(response.statusCode);
      }
    });
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    // String id = widget.id;
    http.Response response = await http.get(
        '${ApiBaseUrl.BASE_URL}/restapi/admin/allusers',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(response.statusCode);
    data = json.decode(response.body);
    setState(() {
      data1 = data['users'];
    });
  }
}
