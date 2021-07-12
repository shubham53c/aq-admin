import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Measurements.dart';
import 'package:intl/intl.dart';
import '../CapitalText.dart';
import '../base_url.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<dynamic> employee, projectStatus, installer;
  CustomSearchDelegate(this.employee, this.projectStatus, this.installer);
  bool listInitialized = false;
  List projectList = [];
  List orders = [];
  int i = 0;
  List<Color> _colors = [
    Colors.orange,
    Colors.red,
    Colors.brown,
    Colors.green,
    Colors.blue
  ];
  String _btn3SelectedVal, id;
  static const menuItems = <String>['View Details', 'Unarchive'];
  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryIconTheme:
          Theme.of(context).primaryIconTheme.copyWith(color: Colors.black),
      primaryColor: Colors.white,
      hintColor: Colors.black,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  Future<void> addMeasure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/allprojects';
    Map data = {
      "assignedTo": 'all',
      "category": "all",
      "projectStatus": 'all',
      "recordPerPage": 1,
    };
    String body = json.encode(data);
    try {
      await http
          .post(
        url,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: body,
      )
          .then((response) async {
        if (response.statusCode == 200) {
          listInitialized = true;
          Map<String, dynamic> data = json.decode(response.body);
          List tem = data['projectList'];
          print('dfdfeee ${tem.length}');
          await addMeasure1(data['totalRecrds']);
        } else {
          print('A network error occurred');
          throw Exception('A network error occurred');
        }
      });
    } catch (e) {
      print('$e');
    }
  }

  Future<void> addMeasure1(int size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/allprojects';
    Map data = {
      "assignedTo": 'all',
      "category": "all",
      "projectStatus": 'all',
      "recordPerPage": size,
    };
    String body = json.encode(data);
    try {
      var response = await http.post(
        url,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: body,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List userData = data['projectList'];
        projectList = userData;
      } else {
        print('A network error occurred');
        throw Exception('A network error occurred');
      }
    } catch (e) {
      print('$e');
    }
  }

  deleteProject(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    // print(id);
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/removearchived/$id';
    try {
      await http.post(
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

          Fluttertoast.showToast(
              msg: "Unarchive",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          //  print(userData[i]['name']);

        } else {
          print(response.statusCode);
          Fluttertoast.showToast(
              msg: "Something went Wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          throw Exception('dfdfdf');
        }
      });
    } catch (e) {
      print('delete project $e');
    }
  }

  Future<List> searchFounds() async {
    if (listInitialized == false) {
      await addMeasure();
    }
    orders.clear();
    for (int i = 0; i < projectList.length; i++) {
      if (projectList[i]['firstname']
          .toString()
          .toLowerCase()
          .startsWith(query.toString().toLowerCase()))
        orders.add(projectList[i]);
    }
    return Future.value(orders);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: searchFounds(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data.length == 0) {
              return Column();
            } else {
              return _buildEventList();
            }
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: orders == null ? 0 : orders.length,
          itemBuilder: (BuildContext context, int index) {
            String formattedDate, pStatus, icon;
            pStatus = orders[index]['projectstatus'];
            if (pStatus == 'created' ||
                pStatus == 'needs estimate' ||
                pStatus == 'needs ordering' ||
                pStatus == 'needs install' ||
                pStatus == 'needs payment') {
              i = 0;
              if (pStatus.contains('created')) {
                icon = 'lib/assets/Measure_Created.png';
              } else if (pStatus.contains('needs estimate')) {
                icon = 'lib/assets/Needs_Estimate.png';
              } else if (pStatus.contains('needs ordering')) {
                icon = 'lib/assets/needs_ordering.png';
              } else if (pStatus.contains('needs install')) {
                icon = 'lib/assets/Needs_Install.png';
              } else if (pStatus.contains('needs payment')) {
                icon = 'lib/assets/Needs_payment.png';
              }
            } else if (pStatus == 'measure incomplete' ||
                pStatus == 'estimate dormant' ||
                pStatus == 'install incomplete') {
              i = 1;
              if (pStatus.contains('measure incomplete')) {
                icon = 'lib/assets/Measure_incomplete.png';
              } else if (pStatus.contains('estimate dormant')) {
                icon = 'lib/assets/estimate_dormant.png';
              } else if (pStatus.contains('install incomplete')) {
                icon = 'lib/assets/install_incomplete.png';
              }
            } else if (pStatus == 'estimate rejected') {
              i = 3;
              icon = 'lib/assets/estimate_rejected.png';
            } else if (pStatus == 'paid') {
              i = 3;
              icon = 'lib/assets/Paid.png';
            } else {
              i = 4;
              if (pStatus.contains('measure assigned')) {
                icon = 'lib/assets/Measure_assigned.png';
              } else if (pStatus.contains('completed')) {
                icon = 'lib/assets/Measure_assigned.png';
              } else if (pStatus.contains('waiting approval')) {
                icon = 'lib/assets/Waiting_Approval.png';
              } else if (pStatus.contains('material ready')) {
                icon = 'lib/assets/Material_ready.png';
              } else if (pStatus.contains('waiting delivery')) {
                icon = 'lib/assets/waiting_delivery.png';
              } else if (pStatus.contains('install assigned')) {
                icon = 'lib/assets/install_assigned.png';
              }
            }
            String id = orders[index]['id'];
            String projectType = orders[index]['projecttype'];
            String measureTime;
            if (orders[index]['inspectiondate'] == null) {
              formattedDate = '-';
            } else {
              var parsedDate = DateTime.parse(orders[index]['inspectiondate']);
              var formatter = new DateFormat.yMMMd();
              formattedDate = formatter.format(parsedDate);
              measureTime =
                  '${DateFormat.jm().format(DateTime.parse(orders[index]['inspectiondate']))}';
              //  print(dateformat);
            }
            return Container(
                margin: EdgeInsets.only(top: 5),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Measurements(
                                  id: id,
                                  employee: employee,
                                  name: 'measure',
                                  installer: installer,
                                  projectStatus: projectStatus,
                                  tabName: projectType == 'measure'
                                      ? "Measure"
                                      : "Install",
                                )),
                      );
                      // .then((value) {
                      //   if (value == true) {
                      //     setState(() {
                      //       val = true;
                      //       orders.clear();
                      //       addMeasure(0, combinedFiltersApplied,
                      //           selectedTeams);
                      //     });
                      //   } else {
                      //     print(value);
                      //   }
                      // });
                    },
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.all(4),
                      child: ClipPath(
                        child: Container(
                          decoration: BoxDecoration(
                              border: makeFirstLetterCapital(
                                          orders[index]['projectstatus']) ==
                                      'Estimate Rejected'
                                  ? Border.all(
                                      color: Colors.red,
                                      width: 2,
                                    )
                                  : makeFirstLetterCapital(
                                              orders[index]['projectstatus']) ==
                                          'Estimate Dormant'
                                      ? Border.all(
                                          color: Colors.brown,
                                          width: 2,
                                        )
                                      : makeFirstLetterCapital(orders[index]
                                                  ['projectstatus']) ==
                                              'Paid'
                                          ? Border.all(
                                              color: Colors.green,
                                              width: 2,
                                            )
                                          : Border(
                                              top: BorderSide(
                                                  color: _colors[i], width: 2),
                                              left: BorderSide(
                                                  color: _colors[i], width: 2),
                                              bottom: BorderSide(
                                                  color: _colors[i], width: 2),
                                              right: BorderSide(
                                                  color: _colors[i],
                                                  width: 2))),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  // IconButton(icon:Icon( Icons.menu), onPressed: (){}),
                                  Container(
                                      height: 30,
                                      width: 50,
                                      child: Image.asset(icon)),
                                  Flexible(
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          orders[index]['firstname']
                                                      .toString() ==
                                                  ' '
                                              ? '${orders[index]['address']}'
                                              : "${orders[index]['firstname']}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.menu,
                                      color: Colors.black,
                                    ),
                                    onSelected: (String newValue) {
                                      if (newValue == "View Details") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Measurements(
                                                    id: id,
                                                    employee: employee,
                                                    name: 'measure',
                                                    installer: installer,
                                                    projectStatus:
                                                        projectStatus,
                                                    tabName: "Measure",
                                                  )),
                                        );
                                        // .then((value) {
                                        //   if (value == true) {
                                        //     setState(() {
                                        //       val = true;
                                        //       orders.clear();
                                        //       addMeasure(
                                        //           0,
                                        //           combinedFiltersApplied,
                                        //           selectedTeams);
                                        //     });
                                        //   } else {
                                        //     print(value);
                                        //   }
                                        // });
                                      } else {
                                        _btn3SelectedVal = newValue;
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0)),
                                              title: Text('Delete Project !'),
                                              content: Text(
                                                  'Are you sure you want to Delete this project ?'),
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
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    // Navigator.pop(context, true);
                                                    // setState(() {
                                                    orders.removeAt(index);

                                                    Navigator.of(
                                                      context,
                                                      // rootNavigator: true,
                                                    ).pop(true);
                                                    // });
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        _popUpMenuItems,
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Center(
                                  child: Row(
                                    children: <Widget>[
                                      formattedDate == '-'
                                          ? Text(
                                              "Dec 30,2020",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              '$formattedDate',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                      Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                          // color: Colors.amber,
                                          color: makeFirstLetterCapital(
                                                      orders[index]
                                                          ['projectstatus']) ==
                                                  'Estimate Dormant'
                                              ? Colors.brown
                                              : makeFirstLetterCapital(orders[
                                                              index]
                                                          ['projectstatus']) ==
                                                      'Estimate Rejected'
                                                  ? Colors.red
                                                  : makeFirstLetterCapital(orders[
                                                                  index][
                                                              'projectstatus']) ==
                                                          'Paid'
                                                      ? Colors.green
                                                      : _colors[i],
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            // "${toBeginningOfSentenceCase(projectstatus[i])}",
                                            "${makeFirstLetterCapital(orders[index]['projectstatus'])}",
                                            // "${orders['firstname']}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      formattedDate == '-'
                                          ? Text(
                                              "Dec 30,2020",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              "$measureTime",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Wrap(children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Assigned To: ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                      OutlineButton(
                                          color: Colors.red,
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          child: Row(
                                            children: <Widget>[
                                              orders[index][
                                                          'inspectionperson'] ==
                                                      null
                                                  ? Text(
                                                      'Select Team',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : Text(
                                                      '${orders[index]['inspectionperson']}',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: orders[index][
                                                                    'projectstatus'] ==
                                                                "measure incomplete"
                                                            ? Colors.red
                                                            : Colors.black,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Measurements(
                                                        id: id,
                                                        employee: employee,
                                                        name: 'measure',
                                                        installer: installer,
                                                        projectStatus:
                                                            projectStatus,
                                                        tabName: "Measure",
                                                      )),
                                            );
                                            // .then((value) {
                                            //   if (value == true) {
                                            //     setState(() {
                                            //       val = true;
                                            //       orders.clear();
                                            //       addMeasure(
                                            //           0,
                                            //           combinedFiltersApplied,
                                            //           selectedTeams);
                                            //     });
                                            //   } else {
                                            //     print(value);
                                            //   }
                                            // });
                                          },
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0)))
                                    ],
                                  )
                                ]),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                    )));
          }),
    );
  }
}
