import 'dart:convert';
import 'dart:io';
import 'package:aq_admin/CapitalText.dart';
import 'package:aq_admin/CreateProject.dart';
import 'package:aq_admin/Drawer.dart';
import 'package:aq_admin/Measurements.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'base_url.dart';

class Measure extends StatefulWidget {
  @override
  _MeasureState createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {
  String _selectedId, changedStatus;
  DateFormat timeformat = DateFormat.jm();

  List<bool> selectedTeamsForFilter = [];
  List<String> selectedTeams = [];

  List status = [
    'created',
    'measure assigned',
    'measure incomplete',
    'completed'
  ];
  String assignedid, name;

  List<Color> _colors = [Colors.orange, Colors.blue, Colors.red, Colors.blue];
  List<Color> _colors1 = [Colors.orange, Colors.blue, Colors.red, Colors.blue];
  static const menuItems = <String>[
    'View Details',
    'Change Status',
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
  int i = 0;
  bool val = true;
  List projectStatus = [
    'created',
    'measure assigned',
    'measure incomplete',
    'completed'
  ];
  int counter = 0;

  noChangeConfirmation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('lastNeedOrderingProjectName');
          return Future.value(true);
        },
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.amber, size: 70),
                Text(
                  '${prefs.getString('lastNeedOrderingProjectName')}\norder is still in\nNEEDS ORDERING\nstatus!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('lastNeedOrderingProjectName');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void incrementCounter() {
    setState(() {
      counter = counter + 1;
      // print(counter);
      // allChats(messege: '$counter');
      addMeasure(counter, 'all', selectedTeams, selectedItems);
    });
  }

  List<bool> temp = [false, false, false];

  Future _handleRefresh() async {
    setState(() {
      // loader = true;
      incrementCounter();
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      addMeasure(0, 'all', selectedTeams, selectedItems);
    } on SocketException {
      print('error');
    }

    addEmployee();
    installerusers();
    addTeams();
    getData();
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

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    http.Response response = await http.get(
        '${ApiBaseUrl.BASE_URL}/restapi/user/profile',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("profile   $data");
    } else {
      print(response.statusCode);
    }
  }

  final RefreshController _refreshController = RefreshController();
  final ScrollController listScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          "Measure",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          // Using Stack to show Notification Badg
          Stack(children: <Widget>[
            IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  modalSheet();
                }),
            isFilter == true
                ? selectedItems.length + selectedTeams.length == 0
                    ? SizedBox()
                    : Positioned(
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
                            "${selectedItems.length + selectedTeams.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                : SizedBox()
            //: new Container()
          ]),
          IconButton(
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
                    String formattedDate, measureTime, measure;
                    if (orders['projectstatus'] == 'created') {
                      i = 0;
                      measure = 'lib/assets/Measure_Created.png';
                    } else if (orders['projectstatus'] == 'measure assigned') {
                      i = 1;
                      measure = 'lib/assets/Measure_assigned.png';
                    } else if (orders['projectstatus'] ==
                        'measure incomplete') {
                      i = 2;
                      measure = 'lib/assets/Measure_incomplete.png';
                    } else {
                      i = 3;
                      measure = 'lib/assets/Measure_Completed.png';
                    }
                    if (orders['inspectiondate'] == null) {
                      formattedDate = '-';
                      measureTime = ' - ';
                    } else {
                      var parsedDate = DateTime.parse(orders['inspectiondate']);
                      var formatter = new DateFormat.yMMMd();
                      formattedDate = formatter.format(parsedDate);
                      measureTime =
                          '${DateFormat.jm().format(DateTime.parse(orders['inspectiondate']))}';
                    }
                    String id = orders['id'];
                    String projectType = orders['projecttype'];
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
                                          tabName: "Measure",
                                        )),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    val = true;
                                    orders.clear();
                                    addMeasure(
                                        0, 'all', selectedTeams, selectedItems);
                                    addEmployee();
                                    installerusers();
                                  });
                                } else {
                                  print(value);
                                }
                              });
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
                                              color: _colors[i], width: 2))),
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
                                                  "${makeFirstLetterCapital(orders['firstname'])}",
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
                                              if (newValue == "View Details") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Measurements(
                                                            id: id,
                                                            employee: employee,
                                                            name: 'measure',
                                                            installer:
                                                                installer,
                                                            projectStatus:
                                                                projectStatus,
                                                            tabName: "Measure",
                                                          )),
                                                ).then((value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      val = true;
                                                      orders.clear();
                                                      addMeasure(
                                                          0,
                                                          'all',
                                                          selectedTeams,
                                                          selectedItems);
                                                      addEmployee();
                                                      installerusers();
                                                    });
                                                  } else {
                                                    print(value);
                                                  }
                                                });
                                              } else if (newValue ==
                                                  "Change Status") {
                                                setState(() {
                                                  if (orders['projectstatus'] !=
                                                      // 'inspectionstatus'] !=
                                                      null) {
                                                    showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          int selectedRadio;
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0)),
                                                            title: Text(
                                                                'Change Status'),
                                                            content:
                                                                StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: List<
                                                                          Widget>.generate(
                                                                      4, (int
                                                                          index) {
                                                                    return RadioListTile(
                                                                      activeColor:
                                                                          _colors1[
                                                                              index],
                                                                      value:
                                                                          index,
                                                                      title: Text(
                                                                          status[
                                                                              index]),
                                                                      groupValue:
                                                                          selectedRadio,
                                                                      onChanged:
                                                                          (int
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          selectedRadio =
                                                                              value;

                                                                          changedStatus =
                                                                              status[index];
                                                                        });
                                                                      },
                                                                    );
                                                                  }),
                                                                );
                                                              },
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                onPressed: () {
                                                                  // Navigator.pop(context, false);
                                                                  Navigator.of(
                                                                    context,
                                                                    // rootNavigator: true,
                                                                  ).pop(false);
                                                                },
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () {
                                                                  // Navigator.pop(context, true);
                                                                  setState(() {
                                                                    orders['projectstatus'] =
                                                                        changedStatus;
                                                                    print(
                                                                        changedStatus);
                                                                    changeStatus(
                                                                        id,
                                                                        projectType,
                                                                        changedStatus);
                                                                    Navigator
                                                                        .of(
                                                                      context,
                                                                      // rootNavigator: true,
                                                                    ).pop(true);
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Submit'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please assigned to employee",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    //  print(userData[i]['name']);

                                                  }
                                                });
                                              } else {
                                                _btn3SelectedVal = newValue;
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
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
                                                              orders.remove();
                                                              deleteProject(id);
                                                              Navigator.of(
                                                                context,
                                                                // rootNavigator: true,
                                                              ).pop(true);
                                                            });
                                                          },
                                                          child: Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
                                            formattedDate == '-'
                                                ? Text(
                                                    "Dec 30, 2020",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    "$formattedDate",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                            Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10.0,
                                              ),
                                              decoration: BoxDecoration(
                                                // color: Colors.amber,
                                                color: _colors[i],
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                              ),
                                              child: Text(
                                                "${makeFirstLetterCapital(orders['projectstatus'])}",
                                                // "${projectStatus[i]}",
                                                // "${orders['firstname']}",projectstatus
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            formattedDate == '-'
                                                ? Text(
                                                    "Dec 30, 2020",
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
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  child: Row(
                                                    children: <Widget>[
                                                      orders['inspectionperson'] ==
                                                              null
                                                          ? Text(
                                                              'Select Team',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            )
                                                          : Text(
                                                              '${orders['inspectionperson']}',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: orders[
                                                                            'projectstatus'] ==
                                                                        "measure incomplete"
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black,
                                                                // Colors
                                                                //     .black,
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
                                                                employee:
                                                                    employee,
                                                                name: 'measure',
                                                                installer:
                                                                    installer,
                                                                projectStatus:
                                                                    projectStatus,
                                                                tabName:
                                                                    "Measure",
                                                              )),
                                                    ).then((value) {
                                                      if (value == true) {
                                                        setState(() {
                                                          val = true;
                                                          orders.clear();
                                                          addMeasure(
                                                              0,
                                                              'all',
                                                              selectedTeams,
                                                              selectedItems);
                                                          addEmployee();
                                                          installerusers();
                                                        });
                                                      } else {
                                                        print(value);
                                                      }
                                                    });
                                                  },
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
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
                  child: Text('No data Found'),
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
                addMeasure(0, 'all', selectedTeams, selectedItems);
                await Future.delayed(Duration(seconds: 2));
                _refreshController.refreshCompleted();
              },
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: listScrollController,
                  itemCount: orders == null ? 0 : orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    String formattedDate, measure;
                    if (orders[index]['projectstatus'] == 'created') {
                      i = 0;
                      measure = 'lib/assets/Measure_Created.png';
                    } else if (orders[index]['projectstatus'] ==
                        'measure assigned') {
                      i = 1;
                      measure = 'lib/assets/Measure_assigned.png';
                    } else if (orders[index]['projectstatus'] ==
                        'measure incomplete') {
                      i = 2;
                      measure = 'lib/assets/Measure_incomplete.png';
                    } else {
                      i = 3;
                      measure = 'lib/assets/Measure_Completed.png';
                    }
                    String id = orders[index]['id'];
                    String projectType = orders[index]['projecttype'];
                    String measureTime;
                    if (orders[index]['inspectiondate'] == null) {
                      formattedDate = '-';
                    } else {
                      var parsedDate =
                          DateTime.parse(orders[index]['inspectiondate']);
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
                                          tabName: "Measure",
                                        )),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    val = true;
                                    orders.clear();
                                    addMeasure(
                                        0, 'all', selectedTeams, selectedItems);
                                    addEmployee();
                                    installerusers();
                                  });
                                } else {
                                  print(value);
                                }
                              });
                            },
                            child: Card(
                              elevation: 3,
                              margin: EdgeInsets.all(4),
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
                                              color: _colors[i], width: 2))),
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
                                              if (newValue == "View Details") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Measurements(
                                                            id: id,
                                                            employee: employee,
                                                            name: 'measure',
                                                            installer:
                                                                installer,
                                                            projectStatus:
                                                                projectStatus,
                                                            tabName: "Measure",
                                                          )),
                                                ).then((value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      val = true;

                                                      orders.clear();
                                                      addMeasure(
                                                          0,
                                                          'all',
                                                          selectedTeams,
                                                          selectedItems);
                                                      addEmployee();
                                                      installerusers();
                                                    });
                                                  } else {
                                                    print(value);
                                                  }
                                                });
                                              } else if (newValue ==
                                                  "Change Status") {
                                                setState(() {
                                                  if (orders[index]
                                                          ['projectstatus'] !=
                                                      null) {
                                                    showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          int selectedRadio;
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0)),
                                                            title: Text(
                                                                'Change Status'),
                                                            content:
                                                                StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: List<
                                                                          Widget>.generate(
                                                                      4, (int
                                                                          index) {
                                                                    return RadioListTile(
                                                                      activeColor:
                                                                          _colors1[
                                                                              index],
                                                                      value:
                                                                          index,
                                                                      title:
                                                                          Text(
                                                                        "${makeFirstLetterCapital(status[index])}",
                                                                      ),
                                                                      groupValue:
                                                                          selectedRadio,
                                                                      onChanged:
                                                                          (int
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          selectedRadio =
                                                                              value;

                                                                          changedStatus =
                                                                              status[index];
                                                                        });
                                                                      },
                                                                    );
                                                                  }),
                                                                );
                                                              },
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                onPressed: () {
                                                                  // Navigator.pop(context, false);
                                                                  Navigator.of(
                                                                    context,
                                                                    // rootNavigator: true,
                                                                  ).pop(false);
                                                                },
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () {
                                                                  // Navigator.pop(context, true);
                                                                  setState(() {
                                                                    orders[index]
                                                                            [
                                                                            'projectstatus'] =
                                                                        changedStatus;
                                                                    if (changedStatus ==
                                                                        'created') {
                                                                      changeStatus(
                                                                          id,
                                                                          projectType,
                                                                          'created');
                                                                    } else if (changedStatus ==
                                                                        'measure assigned') {
                                                                      changeStatus(
                                                                          id,
                                                                          projectType,
                                                                          'assigned');
                                                                    } else if (changedStatus ==
                                                                        'measure incomplete') {
                                                                      changeStatus(
                                                                          id,
                                                                          projectType,
                                                                          'incomplete');
                                                                    } else if (changedStatus ==
                                                                        'completed') {
                                                                      changeStatus(
                                                                          id,
                                                                          projectType,
                                                                          'completed');
                                                                    }

                                                                    Navigator
                                                                        .of(
                                                                      context,
                                                                      // rootNavigator: true,
                                                                    ).pop(true);
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Submit'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please assigned to Team",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    //  print(userData[i]['name']);

                                                  }
                                                });
                                              } else {
                                                _btn3SelectedVal = newValue;
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
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
                                                              orders.removeAt(
                                                                  index);
                                                              deleteProject(id);
                                                              Navigator.of(
                                                                context,
                                                                // rootNavigator: true,
                                                              ).pop(true);
                                                            });
                                                          },
                                                          child: Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 5.0,
                                                  horizontal: 10.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  // color: Colors.amber,
                                                  color: _colors[i],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    // "${toBeginningOfSentenceCase(projectstatus[i])}",
                                                    "${makeFirstLetterCapital(projectStatus[i])}",
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
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  child: Row(
                                                    children: <Widget>[
                                                      orders[index][
                                                                  'inspectionperson'] ==
                                                              null
                                                          ? Text(
                                                              'Select Team',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            )
                                                          : Text(
                                                              '${orders[index]['inspectionperson']}',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: orders[index]
                                                                            [
                                                                            'projectstatus'] ==
                                                                        "measure incomplete"
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black,
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
                                                                employee:
                                                                    employee,
                                                                name: 'measure',
                                                                installer:
                                                                    installer,
                                                                projectStatus:
                                                                    projectStatus,
                                                                tabName:
                                                                    "Measure",
                                                              )),
                                                    ).then((value) {
                                                      if (value == true) {
                                                        setState(() {
                                                          val = true;
                                                          orders.clear();
                                                          addMeasure(
                                                              0,
                                                              'all',
                                                              selectedTeams,
                                                              selectedItems);
                                                          addEmployee();
                                                          installerusers();
                                                        });
                                                      } else {
                                                        print(value);
                                                      }
                                                    });
                                                  },
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (_) => ContactDetails(),
          ));
        },
        child: Icon(FontAwesomeIcons.plus),
        backgroundColor: Color(0xff44aae4),
      ),
    );
  }

  String _btn3SelectedVal, filter, id;

  List userData, employee, installer;
  bool isFilter = false;
  List orders = [];
  int selectedRadio;
  List filterStatus = ['created', 'measure assigned', 'measure incomplete'];
  int selectedMeasure, selectedTeam;
  List<String> selectedItems = [];
  Widget _tabSection(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TabBar(
                tabs: [
                  Tab(
                    child: Stack(
                      children: <Widget>[
                        selectedItems.length != 0
                            ? Positioned(
                                right: 10,
                                top: 2,
                                child: new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 10,
                                  ),
                                  child: Text(
                                    "${selectedItems.length}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Color(0xff44aae4), width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Measure",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Stack(
                      children: <Widget>[
                        selectedTeams.isNotEmpty
                            ? Positioned(
                                right: 10,
                                top: 2,
                                child: new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 10,
                                  ),
                                  child: Text(
                                    "${selectedTeams.length}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Color(0xff44aae4), width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Teams",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                onTap: (tabIndex) {
                  if (tabIndex == 0) {
                    if (isFilter == false) {
                      selectedMeasure = null;
                    } else {
                      if (filterStatus.contains(filter)) {
                        // selectedInstall = null;
                        // selectedOrders = null;
                      }
                    }
                  }
                },
                unselectedLabelColor: Color(0xff44aae4),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff44aae4)),
              ),
            ),
            Expanded(
              child: Container(
                //Add this to give height
                // height: MediaQuery.of(context).size.height,
                child: TabBarView(children: [
                  SingleChildScrollView(
                    child: Container(
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List<Widget>.generate(filterStatus.length,
                                (int index) {
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                value: temp[index],
                                // selected:false,
                                title: Text(
                                    '${makeFirstLetterCapital(filterStatus[index])}'),
                                // groupValue: selectedMeasure,

                                onChanged: (bool value) {
                                  // print('${filterStatus[index]}');
                                  setState(() {
                                    temp[index] = value;
                                    if (temp[index] == true) {
                                      selectedItems.add(filterStatus[index]);
                                      print(selectedItems);
                                    } else if (temp[index] == false) {
                                      selectedItems.remove(filterStatus[index]);
                                      print(selectedItems);
                                    }
                                    // filter = filterStatus[
                                    //     selectedMeasure];
                                  });
                                },
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Container(
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List<Widget>.generate(teams.length,
                                  (int index) {
                                return CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: selectedTeamsForFilter[index],
                                  // selected:false,
                                  title: Text(
                                      '${makeFirstLetterCapital(teams[index]['name'])}'),
                                  // groupValue: selectedMeasure,

                                  onChanged: (bool value) {
                                    setState(() {
                                      selectedTeamsForFilter[index] = value;
                                      if (selectedTeamsForFilter[index]) {
                                        selectedTeams.add(teams[index]['id']);
                                      } else {
                                        selectedTeams
                                            .remove(teams[index]['id']);
                                      }
                                    });
                                    print('selectedTeams: $selectedTeams');
                                  },
                                );
                                // RadioListTile(
                                //   controlAffinity:
                                //       ListTileControlAffinity.trailing,
                                //   value: index,
                                //   title: Text(
                                //       '${makeFirstLetterCapital(teams[index]['name'])}'),
                                //   groupValue: selectedTeam,
                                //   onChanged: (int value) {
                                //     setState(() {
                                //       selectedTeam = value;
                                //       id = teams[index]['id'];

                                //       //  print(employee1);
                                //       // filterStatus = installFilter[selectedInstall];
                                //     });
                                //   },
                                // );
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  modalSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text(
                              '           Filters',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // Spacer(),
                        isFilter == false
                            ? FlatButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  selectedMeasure = null;
                                  selectedTeam = null;
                                  id = null;
                                  Navigator.of(context).pop();
                                  // selectedItems.clear();
                                  // temp = [false, false, false];
                                })
                            : FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    orders.clear();
                                  });
                                  selectedMeasure = null;
                                  selectedTeam = null;
                                  id = null;
                                  val = true;
                                  isFilter = false;
                                  selectedItems.clear();
                                  temp = [false, false, false];
                                  selectedTeams.clear();
                                  selectedTeamsForFilter.clear();
                                  for (int i = 0; i < teams.length; i++) {
                                    selectedTeamsForFilter.add(false);
                                  }
                                  addMeasure(
                                      0, 'all', selectedTeams, selectedItems);
                                },
                                child: Text(
                                  'Clear',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: _tabSection(context),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 150,
                              margin: EdgeInsets.all(4),
                              child: new RaisedButton(
                                child: new Text("Apply"),
                                textColor: Colors.white,
                                color: Color(0xff44aae4),
                                onPressed: () {
                                  Set<dynamic> tempData;
                                  setState(() {
//                                var uniqueIds = employee.map((o) {
//                                  tempData = o.toSet();
//                                  print('tempDAta $tempData');
//                                }).toSet();
//                                print(uniqueIds);
//                                         for(var i in employee){
// var selected =i['name'].toSet().toList();
// print('bbvcsdczbdjkvcsdkjz $selected');
// }
                                    isFilter = true;
                                    print(id);
                                    setState(() {
                                      orders.clear();
                                      val = true;
                                    });
                                    addMeasure(
                                        0, 'all', selectedTeams, selectedItems);
                                    Navigator.pop(context);
                                  });
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(2.0)),
                              )),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  bool _isChecked = false;
  // filterPage() {
  //   showDialog<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12.0)),
  //           title: Text('Filter By'),
  //           content: StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //               return Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children:
  //                     List<Widget>.generate(filterStatus.length, (int index) {
  //                   return CheckboxListTile(
  //                     activeColor: _colors1[index],
  //                     value: _isChecked,
  //                     title: Text(
  //                         '${makeFirstLetterCapital(filterStatus[index])}'),
  //                     // groupValue: selectedRadio,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         _isChecked = value;
  //                         // selectedRadio = value;
  //                       });
  //                     },
  //                   );
  //                 }),
  //               );
  //             },
  //           ),
  //           actions: <Widget>[
  //             isFilter == false
  //                 ? FlatButton(
  //                     child: Text(
  //                       'Cancel',
  //                       style: TextStyle(
  //                           color: Colors.red, fontWeight: FontWeight.bold),
  //                     ),
  //                     onPressed: () {
  //                       selectedRadio = null;
  //                       Navigator.of(context).pop();
  //                     })
  //                 : FlatButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                       orders.clear();
  //                       selectedRadio = null;
  //                       val = true;
  //                       isFilter = false;

  //                       addMeasure(0, 'all', id);
  //                     },
  //                     child: Text(
  //                       'Clear',
  //                       style: TextStyle(
  //                           color: Colors.red, fontWeight: FontWeight.bold),
  //                     )),
  //             FlatButton(
  //               onPressed: () {
  //                 // Navigator.pop(context, true);
  //                 setState(() {
  //                   isFilter = true;
  //                   addMeasure(0, filterStatus[selectedRadio], id);
  //                   Navigator.pop(context);
  //                 });
  //               },
  //               child: Text(
  //                 'Filter',
  //                 style: TextStyle(
  //                     color: Colors.green, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  List<Map<String, dynamic>> teams = [];
  addTeams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url =
        '${ApiBaseUrl.BASE_URL}/restapi/admin/inspectionandmeasurerusers';
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
          Map<String, dynamic> loginData = json.decode(response.body);
          //  userData=loginData;
          List<Map<String, dynamic>> emp =
              List<Map<String, dynamic>>.from(loginData['inspectors']);
          //  emp.insert(0,{'id':'001','name':'Select Team','assigned':false});
          print('emp $emp');

          List<String> uniqueIds = [];
          emp.map((o) {
            print('o $o');
            if (!uniqueIds.contains(o['id'])) {
              uniqueIds.add(o['id']);
            }
          }).toList();
          print('unq $uniqueIds');
          for (int i = 0; i < uniqueIds.length; i++) {
            var temp12 = emp.firstWhere((element) {
              return element['id'] == uniqueIds[i];
            });
            teams.add(temp12);
          }
          for (int i = 0; i < teams.length; i++) {
            selectedTeamsForFilter.add(false);
          }

          // print('temp1 $temp1');

        } else {
          print(response.statusCode);
        }
      });
    } catch (e) {
      print('e $e');
    }
  }

  addEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/inspectionusers';
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
          Map<String, dynamic> loginData = json.decode(response.body);
          //  userData=loginData;
          if (mounted) {
            setState(() {
              employee = loginData['inspectors'];
              employee.insert(
                  0, {'id': '001', 'name': 'Select Team', 'assigned': false});
              print(employee.length);
              //  print(userData[i]['name']);
            });
          }
        } else {
          print(response.statusCode);
          throw Exception('dfdfdf');
        }
      });
    } catch (e) {
      print('add employee $e');
    }
  }

  installerusers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/installerusers';
    try {
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
              print(installer);
              installer.insert(0, {'id': '001', 'name': 'Select Team'});
              //  print(userData[i]['name']);
            });
          }
        } else {
          print(response.statusCode);
          throw Exception('dfdfdf');
        }
      });
    } catch (e) {
      print('install employee $e');
    }
  }

  deleteProject(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/deleteproject/$id';
    try {
      await http.delete(
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
          throw Exception('dfdfdf');
        }
      });
    } catch (e) {
      print('delete project $e');
    }
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
        'projectType': projectType == 'null' ? 'measure' : projectType,
        // 'assignTo': assignedId,
      };
    } else {
      data = {
        'projectId': projectId,
        'projectType': projectType == 'null' ? 'measure' : projectType,
        'assignTo': assignedId,
      };
    }

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
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            projectType = 'measure';
          });
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
          throw Exception('dfdfdf');
        }
      });
    } catch (e) {
      print('employee $e');
    }
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
          throw Exception('dfdfdf');
        }
      });
    } catch (e) {
      print('Status $e');
    }
  }

  addMeasure(int pagenumbercounter, String filter, List<String> assignedTo,
      List<String> items) async {
    print('Page $pagenumbercounter');
    if (pagenumbercounter != null) {
      counter = pagenumbercounter;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print('Logintoken: $token');
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/measureprojects';
    Map data;
    if (items.length == 0 && assignedTo.isEmpty) {
      print('abc');
      data = {
        "assignedTo": 'all',
        "category": "all",
        "pageNumber": counter,
        "projectStatus": 'all',
      };
    } else if (items.isNotEmpty && assignedTo.isNotEmpty) {
      print('xyz');
      print(items);
      data = {
        "assignedTo": 'all',
        "category": "all",
        "pageNumber": counter,
        "projectStatus": 'all',
        "projectStatuss": items,
        "assignedTos": assignedTo,
      };
    } else if (items.isNotEmpty && assignedTo.isEmpty) {
      print('fdfdf111');
      data = {
        "assignedTo": 'all',
        "category": "all",
        "pageNumber": counter,
        "projectStatus": 'all',
        "projectStatuss": items,
      };
    } else if (items.isEmpty && assignedTo.isNotEmpty) {
      print('fdfdfvv');
      data = {
        "assignedTo": 'all',
        "category": "all",
        "pageNumber": counter,
        "projectStatus": 'all',
        "assignedTos": assignedTo,
      };
    }

    String body = json.encode(data);
    try {
      if (filter != 'all') {
        setState(() {
          orders.clear();
          val = true;
        });
      }
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
          Map<String, dynamic> data = json.decode(response.body);
          if (mounted) {
            setState(() {
              userData = data['projectList'];
              print(userData);
              if (userData.length != 0) {
                for (var i in userData) {
                  orders.add(i);
                  val = false;
                }
              } else {
                val = false;
              }

              // print(userData)
              // userData=loginData['inspectors'];
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (null != prefs.getString('lastNeedOrderingProjectName')) {
              noChangeConfirmation();
            }
          }
        } else {
          print('A network error occurred');
          throw Exception('dfdfdf');
        }
      });
    } catch (e) {
      print('dsabchjsdhvhsdzbvhj $e');
    }
  }
}
