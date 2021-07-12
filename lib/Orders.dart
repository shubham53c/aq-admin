import 'dart:convert';
import 'dart:io';
import 'package:aq_admin/CapitalText.dart';
import 'package:aq_admin/Drawer.dart';
import 'package:aq_admin/HomeScreen.dart';
import 'package:aq_admin/Installments.dart';
import 'package:aq_admin/Measurements.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'base_url.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String _selectedId, changedStatus;

  //List status = ['completed', 'assigned', 'incomplete'];

  List projectStatus = [
    'needs estimate',
    'waiting approval',
    'estimate dormant',
    'estimate rejected',
    'needs ordering',
    'waiting delivery',
    'needs install',
    'material ready',
    'measure incomplete'
  ];
  String assignedid, name;
  bool val = true;
  List<Color> _colors = [
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.brown,
    Colors.orange,
    Colors.blue,
    Colors.blue,
    Colors.red
  ];

  List<bool> filterBy = [false, false, false, false, false, false];
  List<String> filterByOrders = [];
  // List<Color> _colors1 = [Colors.blue, Colors.yellow, Colors.red];
  int i = 0;
  static const menuItems = <String>[
    'View Details',
    'Delete',
  ];
  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  String _btn3SelectedVal;
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  int counter = 0;
  void incrementCounter() {
    print('called inc');
    setState(() {
      counter = counter + 1;
      // print(counter);
      // allChats(messege: '$counter');
      addMeasure(counter, filterByOrders.isEmpty ? ['all'] : filterByOrders);
    });
  }

  Future _handleRefresh() async {
    setState(() {
      // loader = true;
      incrementCounter();
    });
  }

  @override
  void initState() {
    super.initState();
    addMeasure(0, ['all']);
    addEmployee();
    installerusers();
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        // print('msg');
        setState(() {
          _handleRefresh();
        });
      }
    });
  }

  final RefreshController _refreshController = RefreshController();
  final ScrollController listScrollController = ScrollController();
  Future<bool> _onBackPressed() {
    return _onback();
  }

  Future _onback() async {
    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.blueGrey[50],
          drawer: MainDrawer(),
          appBar: AppBar(
            title: Text(
              "Orders",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            actions: <Widget>[
              // Using Stack to show Notification Badge
              Stack(children: <Widget>[
                IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      filterPage();
                    }),
                isFilter == true
                    ? filterByOrders.isNotEmpty
                        ? Positioned(
                            right: 11,
                            top: 11,
                            child: new Container(
                              padding: EdgeInsets.all(2),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                "${filterByOrders.length}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : SizedBox()
                    : SizedBox()
                //: new Container()
              ]),

              new IconButton(
                icon: Icon(
                  Icons.search,
                  size: 25,
                ),
                tooltip: 'Search people',
                onPressed: () => showSearch(
                  context: context,
                  delegate: SearchPage(
                      items: orders,
                      searchLabel: 'Search Clients',
                      showItemsOnEmpty: true,
                      suggestion: Center(
                        child: Text(
                            'Filter Orders by Client name,Id,Date or Project Status'),
                      ),
                      failure: Center(
                        child: Text('No Client found :('),
                      ),
                      filter: (orders) {
                        return [
                          orders['firstname'],
                          orders['id'],
                          orders['projectstatus'],
                          orders['date']
                        ];
                      },
                      builder: (orders) {
                        String inspectiondate,
                            assigneddate,
                            measureTime,
                            measure;
                        if (orders['projectstatus'] == 'needs estimate') {
                          i = 0;
                          measure = 'lib/assets/Needs_Estimate.png';
                        } else if (orders['projectstatus'] ==
                            'waiting approval') {
                          i = 1;
                          measure = 'lib/assets/Waiting_Approval.png';
                        } else if (orders['projectstatus'] ==
                            'estimate dormant') {
                          i = 2;
                          measure = 'lib/assets/estimate_dormant.png';
                        } else if (orders['projectstatus'] ==
                            'estimate rejected') {
                          i = 3;
                          measure = 'lib/assets/estimate_rejected.png';
                        } else if (orders['projectstatus'] ==
                            'needs ordering') {
                          i = 4;
                          measure = 'lib/assets/needs_ordering.png';
                        } else if (orders['projectstatus'] ==
                            'waiting delivery') {
                          i = 5;
                          measure = 'lib/assets/waiting_delivery.png';
                        } else if (orders['projectstatus'] ==
                            'material ready') {
                          i = 6;
                          measure = 'lib/assets/Material_ready.png';
                        }

                        if (orders['inspectiondate'] == null) {
                          inspectiondate = ' - ';
                        } else {
                          var parsedDate =
                              DateTime.parse(orders['inspectiondate']);
                          var formatter = new DateFormat.yMMMd();
                          inspectiondate = formatter.format(parsedDate);
                          measureTime =
                              '${DateFormat.jm().format(DateTime.parse(orders['inspectiondate']))}';
                        }
                        if (orders['assigneddate'] == null) {
                          assigneddate = ' - ';
                        } else {
                          var parsedDate =
                              DateTime.parse(orders['assigneddate']);
                          var formatter = new DateFormat.yMMMd();
                          assigneddate = formatter.format(parsedDate);
                        }
                        String id = orders['id'];
                        String projectType = orders['projecttype'];
                        return Container(
                            margin: EdgeInsets.only(top: 5),
                            child: GestureDetector(
                                onTap: () {
                                  if (projectType == 'measure') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Measurements(
                                                id: id,
                                                employee: employee,
                                                name: 'measure',
                                                installer: installer,
                                                projectStatus: projectStatus,
                                                tabName: 'Orders',
                                              )),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          val = true;
                                          orders.clear();
                                          addMeasure(0, ['all']);
                                          addEmployee();
                                          installerusers();
                                        });
                                      } else {
                                        print(value);
                                      }
                                    });
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Measurements(
                                                id: id,
                                                employee: employee,
                                                name: 'install',
                                                installer: installer,
                                                projectStatus: projectStatus,
                                                tabName: 'Orders',
                                              )),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          orders.clear();
                                          addMeasure(0, ['all']);
                                          addEmployee();
                                          installerusers();
                                        });
                                      } else {
                                        print(value);
                                      }
                                    });
                                  }
                                },
                                child: Card(
                                  elevation: 3,
                                  margin: EdgeInsets.all(5),
                                  child: ClipPath(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              // IconButton(icon:Icon( Icons.menu), onPressed: (){}),
                                              Container(
                                                  height: 30,
                                                  width: 50,
                                                  child: Image.asset(measure)),
                                              Flexible(
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      "${orders['firstname']}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                  if (newValue ==
                                                      "View Details") {
                                                    if (projectType ==
                                                        'measure') {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Measurements(
                                                                  id: id,
                                                                  employee:
                                                                      employee,
                                                                  name:
                                                                      'measure',
                                                                  installer:
                                                                      installer,
                                                                  projectStatus:
                                                                      projectStatus,
                                                                  tabName:
                                                                      'Orders',
                                                                )),
                                                      ).then((value) {
                                                        if (value == true) {
                                                          setState(() {
                                                            val = true;
                                                            orders.clear();
                                                            addMeasure(
                                                                0, ['all']);
                                                            addEmployee();
                                                            installerusers();
                                                          });
                                                        } else {
                                                          print(value);
                                                        }
                                                      });
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Measurements(
                                                                  id: id,
                                                                  employee:
                                                                      employee,
                                                                  name:
                                                                      'install',
                                                                  installer:
                                                                      installer,
                                                                  projectStatus:
                                                                      projectStatus,
                                                                  tabName:
                                                                      'Orders',
                                                                )),
                                                      ).then((value) {
                                                        if (value == true) {
                                                          setState(() {
                                                            orders.clear();
                                                            addMeasure(
                                                                0, ['all']);
                                                            addEmployee();
                                                            installerusers();
                                                          });
                                                        } else {
                                                          print(value);
                                                        }
                                                      });
                                                    }
                                                  } else {
                                                    _btn3SelectedVal = newValue;
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0)),
                                                          title: Text(
                                                              'Delete Project !'),
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
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () {
                                                                // Navigator.pop(context, true);
                                                                setState(() {
                                                                  orders
                                                                      .removeAt();
                                                                  deleteProject(
                                                                      id);
                                                                  Navigator.of(
                                                                    context,
                                                                    // rootNavigator: true,
                                                                  ).pop(true);
                                                                });
                                                              },
                                                              child: Text(
                                                                'Yes',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        _popUpMenuItems,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Row(
                                              children: <Widget>[
                                                inspectiondate == null
                                                    ? Text(
                                                        // "Date : "
                                                        "jan 12,2021",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : Text(
                                                        "$inspectiondate",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                Spacer(),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 5.0,
                                                    horizontal: 10.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.amber,
                                                    color: _colors[i],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                  ),
                                                  child: Text(
                                                    //  "${orders['inspectionstatus']}",
                                                    "${makeFirstLetterCapital(projectStatus[i])}",
                                                    // '${toBeginningOfSentenceCase(orders['projectstatus'])}',
                                                    // "${orders['firstname']}",

                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                inspectiondate == null
                                                    ? Text(
                                                        // "Date : "
                                                        "jan 12,2021",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
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
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
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
                                                      borderSide: BorderSide(
                                                          color: Colors.white),
                                                      child:
                                                          projectType ==
                                                                  'measure'
                                                              ? Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      orders['inspectionperson'] ==
                                                                              null
                                                                          ? 'Select Team'
                                                                          : '${orders['inspectionperson']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      orders['assignedtoperson'] ==
                                                                              null
                                                                          ? 'Select Team'
                                                                          : '${orders['assignedtoperson']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    orders['assignedtoperson'] ==
                                                                            null
                                                                        ? Icon(
                                                                            Icons.arrow_drop_down,
                                                                            color:
                                                                                Colors.red,
                                                                          )
                                                                        : Icon(
                                                                            Icons.arrow_drop_down,
                                                                            color:
                                                                                Colors.black,
                                                                          )
                                                                  ],
                                                                ),
                                                      onPressed: () {
                                                        if (projectType ==
                                                            'measure') {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Measurements(
                                                                          id: id,
                                                                          employee:
                                                                              employee,
                                                                          name:
                                                                              'measure',
                                                                          installer:
                                                                              installer,
                                                                          projectStatus:
                                                                              projectStatus,
                                                                          tabName:
                                                                              'Orders',
                                                                        )),
                                                          ).then((value) {
                                                            if (value == true) {
                                                              setState(() {
                                                                val = true;
                                                                orders.clear();
                                                                addMeasure(
                                                                    0, ['all']);
                                                                addEmployee();
                                                                installerusers();
                                                              });
                                                            } else {
                                                              print(value);
                                                            }
                                                          });
                                                        }
                                                      },
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  30.0)))
                                                ],
                                              )
                                            ]),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )));
                      }),
                ),
              ),
            ],
          ),
          body: orders == null || orders.length == 0
              ? val
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: Text('No Data Found'),
                    )
              : SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  scrollController: listScrollController,
                  onLoading: () async {
                    await Future.delayed(Duration(seconds: 2));
                    _refreshController.loadComplete();
                  },
                  onRefresh: () async {
                    orders.clear();
                    addMeasure(
                        0, filterByOrders.isEmpty ? ['all'] : filterByOrders);
                    await Future.delayed(Duration(seconds: 2));
                    _refreshController.refreshCompleted();
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: listScrollController,
                      itemCount: orders == null ? 0 : orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        // if (orders[index]['projectstatus'] == 'completed') {
                        //   i = 1;
                        // } else if (orders[index]['projectstatus'] ==
                        //     'assigned') {
                        //   i = 0;
                        // } else {
                        //   i = 2;
                        // }
                        String measure;
                        if (orders[index]['projectstatus'] ==
                            'needs estimate') {
                          i = 0;
                          measure = 'lib/assets/Needs_Estimate.png';
                        } else if (orders[index]['projectstatus'] ==
                            'waiting approval') {
                          i = 1;
                          measure = 'lib/assets/Waiting_Approval.png';
                        } else if (orders[index]['projectstatus'] ==
                            'estimate dormant') {
                          i = 2;
                          measure = 'lib/assets/estimate_dormant.png';
                        } else if (orders[index]['projectstatus'] ==
                            'estimate rejected') {
                          i = 3;
                          measure = 'lib/assets/estimate_rejected.png';
                        } else if (orders[index]['projectstatus'] ==
                            'needs ordering') {
                          i = 4;
                          measure = 'lib/assets/needs_ordering.png';
                        } else if (orders[index]['projectstatus'] ==
                            'waiting delivery') {
                          i = 5;
                          measure = 'lib/assets/waiting_delivery.png';
                        } else if (orders[index]['projectstatus'] ==
                            'material ready') {
                          i = 6;
                          measure = 'lib/assets/Material_ready.png';
                        }
                        String inspectiondate, assigneddate, measureTime;
                        if (orders[index]['inspectiondate'] == null) {
                          inspectiondate = ' - ';
                        } else {
                          var parsedDate =
                              DateTime.parse(orders[index]['inspectiondate']);
                          var formatter = new DateFormat.yMMMd();
                          inspectiondate = formatter.format(parsedDate);
                          measureTime =
                              '${DateFormat.jm().format(DateTime.parse(orders[index]['inspectiondate']))}';
                        }

                        if (orders[index]['assigneddate'] == null) {
                          assigneddate = ' - ';
                        } else {
                          var parsedDate =
                              DateTime.parse(orders[index]['assigneddate']);
                          var formatter = new DateFormat.yMMMd();
                          assigneddate = formatter.format(parsedDate);
                        }
                        String id = orders[index]['id'];
                        String projectType = orders[index]['projecttype'];

                        return Container(
                            margin: EdgeInsets.only(top: 5),
                            child: GestureDetector(
                                onTap: () {
                                  if (projectType == 'measure') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Measurements(
                                                id: id,
                                                employee: employee,
                                                name: 'measure',
                                                installer: installer,
                                                projectStatus: projectStatus,
                                                tabName: 'Orders',
                                              )),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          val = true;
                                          orders.clear();
                                          addMeasure(0, ['all']);
                                          addEmployee();
                                          installerusers();
                                        });
                                      } else {
                                        print(value);
                                      }
                                    });
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Measurements(
                                                id: id,
                                                employee: employee,
                                                name: 'install',
                                                installer: installer,
                                                projectStatus: projectStatus,
                                                tabName: 'Orders',
                                              )),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          orders.clear();
                                          addMeasure(0, ['all']);
                                          addEmployee();
                                          installerusers();
                                        });
                                      } else {
                                        print(value);
                                      }
                                    });
                                  }
                                },
                                child: Card(
                                  elevation: 3,
                                  margin: EdgeInsets.all(5),
                                  child: ClipPath(
                                    clipper: ShapeBorderClipper(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3))),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              // IconButton(icon:Icon( Icons.menu), onPressed: (){}),
                                              Container(
                                                  height: 30,
                                                  width: 50,
                                                  child: Image.asset(measure)),
                                              Flexible(
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      orders[index]['firstname'] ==
                                                                  ' ' ||
                                                              orders[index][
                                                                      'firstname'] ==
                                                                  ''
                                                          ? "${orders[index]['address']}"
                                                          : "${makeFirstLetterCapital(orders[index]['firstname'])}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                  if (newValue ==
                                                      "View Details") {
                                                    if (projectType ==
                                                        'measure') {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Measurements(
                                                                  id: id,
                                                                  employee:
                                                                      employee,
                                                                  name:
                                                                      'measure',
                                                                  installer:
                                                                      installer,
                                                                  projectStatus:
                                                                      projectStatus,
                                                                  tabName:
                                                                      'Orders',
                                                                )),
                                                      ).then((value) {
                                                        if (value == true) {
                                                          setState(() {
                                                            val = true;
                                                            orders.clear();
                                                            addMeasure(
                                                                0, ['all']);
                                                            addEmployee();
                                                            installerusers();
                                                          });
                                                        } else {
                                                          print(value);
                                                        }
                                                      });
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Measurements(
                                                                  id: id,
                                                                  employee:
                                                                      employee,
                                                                  name:
                                                                      'install',
                                                                  installer:
                                                                      installer,
                                                                  projectStatus:
                                                                      projectStatus,
                                                                  tabName:
                                                                      'Orders',
                                                                )),
                                                      ).then((value) {
                                                        if (value == true) {
                                                          setState(() {
                                                            orders.clear();
                                                            addMeasure(
                                                                0, ['all']);
                                                            addEmployee();
                                                            installerusers();
                                                          });
                                                        } else {
                                                          print(value);
                                                        }
                                                      });
                                                    }
                                                  } else {
                                                    _btn3SelectedVal = newValue;
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0)),
                                                          title: Text(
                                                              'Delete Project !'),
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
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () {
                                                                // Navigator.pop(context, true);
                                                                setState(() {
                                                                  orders
                                                                      .removeAt(
                                                                          index);
                                                                  deleteProject(
                                                                      id);
                                                                  Navigator.of(
                                                                    context,
                                                                    // rootNavigator: true,
                                                                  ).pop(true);
                                                                });
                                                              },
                                                              child: Text(
                                                                'Yes',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        _popUpMenuItems,
                                              ),
                                            ],
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Row(
                                              children: <Widget>[
                                                inspectiondate == null
                                                    ? Text(
                                                        // "Date : "
                                                        "jan 12,2021",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : Text(
                                                        "$inspectiondate",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                Spacer(),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 5.0,
                                                    horizontal: 10.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.amber,
                                                    color: _colors[i],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                  ),
                                                  child: Text(
                                                    //  "${orders['inspectionstatus']}",
                                                    "${makeFirstLetterCapital(projectStatus[i])}",
                                                    //  '${toBeginningOfSentenceCase(orders[index]['projectstatus'])}',
                                                    // "${orders['firstname']}",

                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                inspectiondate == null
                                                    ? Text(
                                                        // "Date : "
                                                        "12,jan 2021",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : Text(
                                                        //  "Date : "
                                                        "$measureTime",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
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
                                                      borderSide: BorderSide(
                                                          color: Colors.white),
                                                      child:
                                                          projectType ==
                                                                  'measure'
                                                              ? Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      orders[index]['inspectionperson'] ==
                                                                              null
                                                                          ? 'Select Team'
                                                                          : '${orders[index]['inspectionperson']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      orders[index]['assignedtoperson'] ==
                                                                              null
                                                                          ? 'Select Team'
                                                                          : '${orders[index]['assignedtoperson']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    orders[index]['assignedtoperson'] ==
                                                                            null
                                                                        ? Icon(
                                                                            Icons.arrow_drop_down,
                                                                            color:
                                                                                Colors.red,
                                                                          )
                                                                        : Icon(
                                                                            Icons.arrow_drop_down,
                                                                            color:
                                                                                Colors.black,
                                                                          )
                                                                  ],
                                                                ),
                                                      onPressed: () {
                                                        if (projectType ==
                                                            'measure') {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Measurements(
                                                                          id: id,
                                                                          employee:
                                                                              employee,
                                                                          name:
                                                                              'measure',
                                                                          installer:
                                                                              installer,
                                                                          projectStatus:
                                                                              projectStatus,
                                                                          tabName:
                                                                              'Orders',
                                                                        )),
                                                          ).then((value) {
                                                            if (value == true) {
                                                              setState(() {
                                                                val = true;
                                                                orders.clear();
                                                                addMeasure(
                                                                    0, ['all']);
                                                                addEmployee();
                                                                installerusers();
                                                              });
                                                            } else {
                                                              print(value);
                                                            }
                                                          });
                                                        }
                                                      },
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  30.0)))
                                                ],
                                              )
                                            ]),
                                          ),

                                          // SizedBox(
                                          //   height: 10,
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                )));
                      }),
                ),
        ));
  }

  List userData, employee, installer;
  List orders = [];
  bool isFilter = false;
  int selectedRadio;
  List filterStatus = [
    'needs estimate',
    'waiting approval',
    'estimate dormant',
    'estimate rejected',
    'needs ordering',
    'waiting delivery'
  ];

  filterPage() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            title: Center(child: Text('Filter By')),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      List<Widget>.generate(filterStatus.length, (int index) {
                    return CheckboxListTile(
                        title: Text(
                            '${makeFirstLetterCapital(filterStatus[index])}'),
                        value: filterBy[index],
                        onChanged: (val) {
                          setState(() {
                            filterBy[index] = val;
                            if (filterBy[index]) {
                              filterByOrders.add('${filterStatus[index]}');
                            } else {
                              filterByOrders.remove('${filterStatus[index]}');
                            }
                          });
                          print('Filter By: $filterByOrders');
                        });
                    // RadioListTile(
                    //   value: index,
                    //   title: Text(
                    //       '${makeFirstLetterCapital(filterStatus[index])}'),
                    //   groupValue: selectedRadio,
                    //   onChanged: (int value) {
                    //     setState(() {
                    //       selectedRadio = value;
                    //     });
                    //   },
                    // );
                  }),
                );
              },
            ),
            actions: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          // Navigator.pop(context, true);
                          setState(() {
                            isFilter = true;
                            orders.clear();
                            val = true;
                            addMeasure(
                                0,
                                filterByOrders.isEmpty
                                    ? ['all']
                                    : filterByOrders);
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'Filter',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                      isFilter == false
                          ? FlatButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                selectedRadio = null;
                                Navigator.of(context).pop();
                              })
                          : FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  orders.clear();
                                });
                                filterByOrders.clear();
                                filterBy = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                                selectedRadio = null;
                                val = true;
                                isFilter = false;

                                addMeasure(0, ['all']);
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )),
                    ],
                  ))
            ],
          );
        });
  }

  addEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/inspectionusers';
    http.post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    ).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> loginData = json.decode(response.body);
        //  userData=loginData;
        if (mounted) {
          setState(() {
            employee = loginData['inspectors'];
            print(employee.length);
            employee.insert(
                0, {'id': '001', 'name': 'Select Team', 'assigned': false});
            //  print(userData[i]['name']);
          });
        }
      } else {
        print(response.statusCode);
      }
    });
  }

  deleteProject(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/deleteproject/$id';
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
          Fluttertoast.showToast(
              msg: "Deleted Project ID :$id",
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

  assignedEmployee(String projectId, assignedId, name, projectType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    Map data;
    print(projectId);
    print(assignedId);
    print(name);
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/assignforproject';
    if (assignedId == '001') {
      data = {
        'projectId': projectId,
        'projectType': projectType,
        //  'assignTo': assignedId,
      };
    } else {
      data = {
        'projectId': projectId,
        'projectType': projectType,
        'assignTo': assignedId,
      };
    }
    String body = json.encode(data);
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
        print(response.statusCode);
        Fluttertoast.showToast(
            msg: "Assigned to :$name ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print(response.statusCode);
      }
    });
  }

  installerusers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/installerusers';
    http.post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    ).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> loginData = json.decode(response.body);
        //  userData=loginData;
        if (mounted) {
          setState(() {
            installer = loginData['inspectors'];
            installer.insert(
                0, {'id': '001', 'name': 'Select Team', 'assigned': false});
            print(installer);
            //  print(userData[i]['name']);
          });
        }
      } else {
        print(response.statusCode);
      }
    });
  }

  changeStatus(String projectId, projectType, status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print(token);
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/changeprojecttypestatus';
    Map data = {
      'projectId': projectId,
      'projectType': projectType,
      'status': status,
    };
    String body = json.encode(data);
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
      //  String body=json.decode(response.body);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.statusCode);
        Fluttertoast.showToast(
            msg: "Status :$status ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print(response.statusCode);
      }
    });
  }

  addMeasure(int pagenumbercounter, List<String> filter) async {
    if (pagenumbercounter != null) {
      counter = pagenumbercounter;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/orderprojects';
    Map data;
    print('page: $pagenumbercounter');
    print('filterlist $filter');
    if (filter.contains('all')) {
      print('order Filters removed');
      data = {
        "assignedTo": "all",
        "category": "all",
        "pageNumber": counter,
        "projectStatus": "all"
      };
    } else {
      print('order Filters applied');
      data = {
        "assignedTo": "all",
        "category": "all",
        "projectStatus": "all",
        "pageNumber": counter,
        "projectStatuss": filter,
      };
    }
    String body = json.encode(data);
    // if (filter.first != 'all') {
    //   print('fdffdf called');
    //   setState(() {
    //     orders.clear();
    //     val = true;
    //   });
    // }
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
        Map<String, dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            userData = data['projectList'];
            print('userData $userData');
            if (userData.length != 0) {
              for (var i in userData) {
                print(userData.length);
                orders.add(i);
                val = false;
              }
            } else {
              val = false;
            }
            // for (var i in userData) {
            //  if (i['projecttype'] == 'measure' ) {
            //   if (i['projectstatus'] == 'needs estimate'||i['projectstatus'] == 'waiting approval'||i['projectstatus'] == 'estimate dormant'||i['projectstatus'] == 'estimate rejected'||i['projectstatus'] == 'needs ordering'||i['projectstatus'] == 'waiting delivery'||i['projectstatus'] == 'material ready') {
            //     orders.add(i);
            //     print(orders);
            //     val = false;
            //   }
            // } else {
            //   val = false;
            // }
            // }
          });
        }
      } else {
        print(response.statusCode);
      }
    });
  }
}
