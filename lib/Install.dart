import 'dart:convert';
import 'dart:io';
import 'package:aq_admin/CapitalText.dart';
import 'package:aq_admin/HomeScreen.dart';
import 'package:aq_admin/Measurements.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Drawer.dart';
import 'base_url.dart';

class Install extends StatefulWidget {
  @override
  _InstallState createState() => _InstallState();
}

class _InstallState extends State<Install> {
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

  String _selectedId, changedStatus, _btn3SelectedVal;

  List<bool> installFilters = [false, false, false, false, false];
  List<String> installFiltersApplied = [];
  List<bool> availableTeams = [];
  List<String> selectedTeams = [];

  // List status = ['completed', 'assigned', 'incomplete','paid'];
  List status = [
    'waiting delivery',
    'needs install',
    'install assigned',
    'install incomplete',
    'needs payment',
    'paid'
  ];
  String assignedid, name;
// List projectStatus=['install assigned','install incomplete','needs payment','paid','need install'];
  List projectStatus = [
    'waiting delivery',
    'needs install',
    'install assigned',
    'install incomplete',
    'needs payment',
    'paid'
  ];
  static const menuItems = <String>['View Details', 'Change Status', 'Delete'];
  final List<PopupMenuItem<String>> _popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  List<Color> _colors = [
    Colors.blue,
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.orange[300],
    Colors.green
  ];
  List<Color> _colors1 = [
    Colors.blue,
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.orange[300],
    Colors.green
  ];
  int i = 0;
  bool val = true;
  final RefreshController _refreshController = RefreshController();
  final ScrollController listScrollController = ScrollController();
  int counter = 0;
  void incrementCounter() {
    setState(() {
      counter = counter + 1;
      // print(counter);
      // allChats(messege: '$counter');
      addMeasure(counter, installFiltersApplied, selectedTeams);
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
    addMeasure(0, installFiltersApplied, selectedTeams);
    addEmployee();
    installerusers();
    addTeams();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          "Install",
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
                ? installFiltersApplied.length + selectedTeams.length > 0
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
                            "${installFiltersApplied.length + selectedTeams.length}",
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
                  showItemsOnEmpty: true,
                  items: orders,
                  searchLabel: 'Search Clients',
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
                    String assigneddate, measureTime, measure;
                    if (orders['projectstatus'] == 'waiting delivery') {
                      i = 0;
                      measure = 'lib/assets/waiting_delivery.png';
                    } else if (orders['projectstatus'] == 'needs install') {
                      i = 1;
                      measure = 'lib/assets/Needs_Install.png';
                    } else if (orders['projectstatus'] == 'install assigned') {
                      i = 2;
                      measure = 'lib/assets/install_assigned.png';
                    } else if (orders['projectstatus'] ==
                        'install incomplete') {
                      i = 3;
                      measure = 'lib/assets/install_incomplete.png';
                    } else if (orders['projectstatus'] == 'needs payment') {
                      i = 4;
                      measure = 'lib/assets/Needs_payment.png';
                    } else if (orders['projectstatus'] == 'paid') {
                      i = 5;
                      measure = 'lib/assets/Paid.png';
                    }
                    if (orders['assigneddate'] == null) {
                      assigneddate = ' - ';
                      measureTime = ' - ';
                    } else {
                      var parsedDate = DateTime.parse(orders['assigneddate']);
                      var formatter = new DateFormat.yMMMd();
                      assigneddate = formatter.format(parsedDate);
                      measureTime =
                          '${DateFormat.jm().format(DateTime.parse(orders['assigneddate']))}';
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
                                          name: 'install',
                                          installer: installer,
                                          projectStatus: projectStatus,
                                          tabName: "Install",
                                        )),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    val = true;
                                    orders.clear();
                                    addMeasure(0, installFiltersApplied,
                                        selectedTeams);
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
                                          Container(
                                              height: 30,
                                              width: 50,
                                              child: Image.asset(measure)),
                                          Flexible(
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  orders['firstname'] == null ||
                                                          orders['firstname'] ==
                                                              " " ||
                                                          orders['firstname'] ==
                                                              ""
                                                      ? "Refer address"
                                                      : "${orders['firstname']}",
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
                                          // IconButton(icon:Icon( Icons.menu), onPressed: (){}),

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
                                                            name: 'install',
                                                            installer:
                                                                installer,
                                                            projectStatus:
                                                                projectStatus,
                                                            tabName: "Install",
                                                          )),
                                                ).then((value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      val = true;
                                                      orders.clear();
                                                      addMeasure(
                                                          0,
                                                          installFiltersApplied,
                                                          selectedTeams);
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
                                                                    6, (int
                                                                        index) {
                                                                  return RadioListTile(
                                                                    activeColor:
                                                                        _colors1[
                                                                            index],
                                                                    value:
                                                                        index,
                                                                    title: Text(
                                                                        "${makeFirstLetterCapital(status[index])}"),
                                                                    groupValue:
                                                                        selectedRadio,
                                                                    onChanged: (int
                                                                        value) {
                                                                      setState(
                                                                          () {
                                                                        selectedRadio =
                                                                            value;
                                                                        changedStatus =
                                                                            status[index];
                                                                        print(
                                                                            changedStatus);
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
                                                                  changeStatus(
                                                                      id,
                                                                      projectType,
                                                                      changedStatus);
                                                                  Navigator.of(
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
                                            assigneddate == null
                                                ? Text(
                                                    "12 jan,2021",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Text(
                                                    "$assigneddate",
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
                                                "${makeFirstLetterCapital(projectStatus[i])}",
                                                //"${toBeginningOfSentenceCase(orders['projectstatus'])}",

                                                // "${orders['firstname']}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            assigneddate == null
                                                ? Text(
                                                    // "Date : "
                                                    "12 jan,2021",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Text(
                                                    // "Date : "
                                                    "$measureTime",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  )
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
                                                      Text(
                                                        orders['assignedtoperson'] ==
                                                                null
                                                            ? 'Select Team'
                                                            : '${orders['assignedtoperson']}',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: orders['assignedtoperson'] ==
                                                                      null ||
                                                                  orders['projectstatus'] ==
                                                                      "install incomplete"
                                                              ? Colors.red
                                                              : Colors.black,
                                                          //        orders
                                                          //     ['assignedtoperson'] ==
                                                          // null?Colors.red:Colors.black,
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
                                                                name: 'install',
                                                                installer:
                                                                    installer,
                                                                projectStatus:
                                                                    projectStatus,
                                                                tabName:
                                                                    "Install",
                                                              )),
                                                    ).then((value) {
                                                      if (value == true) {
                                                        setState(() {
                                                          val = true;
                                                          orders.clear();
                                                          addMeasure(
                                                              0,
                                                              installFiltersApplied,
                                                              selectedTeams);
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
                addMeasure(0, installFiltersApplied, selectedTeams);
                await Future.delayed(Duration(seconds: 2));
                _refreshController.refreshCompleted();
              },
              child: ListView.builder(
                  controller: listScrollController,
                  shrinkWrap: true,
                  itemCount: orders == null ? 0 : orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    String assigneddate, measureTime, measure;
                    // if (orders[index]['installationstatus'] == 'completed') {
                    //   i = 1;
                    // } else if (orders[index]['installationstatus'] == 'assigned') {
                    //   i = 0;
                    // } else if (orders[index]['installationstatus'] == 'incomplete'){
                    //   i = 2;
                    // }else{
                    //   i=3;
                    // }
                    if (orders[index]['projectstatus'] == 'waiting delivery') {
                      i = 0;
                      measure = 'lib/assets/waiting_delivery.png';
                    } else if (orders[index]['projectstatus'] ==
                        'needs install') {
                      i = 1;
                      measure = 'lib/assets/Needs_Install.png';
                    } else if (orders[index]['projectstatus'] ==
                        'install assigned') {
                      i = 2;
                      measure = 'lib/assets/install_assigned.png';
                    } else if (orders[index]['projectstatus'] ==
                        'install incomplete') {
                      i = 3;
                      measure = 'lib/assets/install_incomplete.png';
                    } else if (orders[index]['projectstatus'] ==
                        'needs payment') {
                      i = 4;
                      measure = 'lib/assets/Needs_payment.png';
                    } else if (orders[index]['projectstatus'] == 'paid') {
                      i = 5;
                      measure = 'lib/assets/Paid.png';
                    }
                    if (orders[index]['assigneddate'] == null) {
                      assigneddate = ' - ';
                      measureTime = ' - ';
                    } else {
                      var parsedDate =
                          DateTime.parse(orders[index]['assigneddate']);
                      var formatter = new DateFormat.yMMMd();
                      assigneddate = formatter.format(parsedDate);
                      measureTime =
                          '${DateFormat.jm().format(DateTime.parse(orders[index]['assigneddate']))}';
                    }
                    String id = orders[index]['id'];
                    String projectType = orders[index]['projecttype'];

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
                                          name: 'install',
                                          installer: installer,
                                          projectStatus: projectStatus,
                                          tabName: "Install",
                                        )),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    val = true;
                                    orders.clear();
                                    addMeasure(0, installFiltersApplied,
                                        selectedTeams);
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
                                                  orders[index]['firstname'] ==
                                                          ' '
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
                                                            name: 'install',
                                                            installer:
                                                                installer,
                                                            projectStatus:
                                                                projectStatus,
                                                            tabName: "Install",
                                                          )),
                                                ).then((value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      val = true;
                                                      orders.clear();
                                                      addMeasure(
                                                          0,
                                                          installFiltersApplied,
                                                          selectedTeams);
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
                                                                    6, (int
                                                                        index) {
                                                                  return RadioListTile(
                                                                    activeColor:
                                                                        _colors1[
                                                                            index],
                                                                    value:
                                                                        index,
                                                                    title: Text(
                                                                        "${makeFirstLetterCapital(status[index])}"),
                                                                    groupValue:
                                                                        selectedRadio,
                                                                    onChanged: (int
                                                                        value) {
                                                                      setState(
                                                                          () {
                                                                        selectedRadio =
                                                                            value;
                                                                        changedStatus =
                                                                            status[index];
                                                                        print(
                                                                            changedStatus);
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
                                                                  orders[index][
                                                                          'projectstatus'] =
                                                                      changedStatus;
                                                                  if (changedStatus ==
                                                                      'install assigned') {
                                                                    changeStatus(
                                                                        id,
                                                                        projectType,
                                                                        'assigned');
                                                                  } else if (changedStatus ==
                                                                      'install incomplete') {
                                                                    changeStatus(
                                                                        id,
                                                                        projectType,
                                                                        'incomplete');
                                                                  } else if (changedStatus ==
                                                                      'needs payment') {
                                                                    changeStatus(
                                                                        id,
                                                                        projectType,
                                                                        'completed');
                                                                  } else {
                                                                    changeStatus(
                                                                        id,
                                                                        projectType,
                                                                        changedStatus);
                                                                  }

                                                                  Navigator.of(
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
                                        child: Row(
                                          children: <Widget>[
                                            assigneddate == null
                                                ? Text(
                                                    // "Date : "
                                                    "12 jan,2021",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Text(
                                                    "$assigneddate",
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
                                                "${toBeginningOfSentenceCase(projectStatus[i])}",
                                                //"${toBeginningOfSentenceCase(orders[index]['projectstatus'])}",
                                                // "${orders['firstname']}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            assigneddate == null
                                                ? Text(
                                                    // "Date : "
                                                    "12 jan,2021",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Text(
                                                    // "Date : "
                                                    "$measureTime",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  )
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
                                                      Text(
                                                        orders[index][
                                                                    'assignedtoperson'] ==
                                                                null
                                                            ? 'Select Team'
                                                            : '${orders[index]['assignedtoperson']}',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: orders[index][
                                                                          'assignedtoperson'] ==
                                                                      null ||
                                                                  orders[index][
                                                                          'projectstatus'] ==
                                                                      "install incomplete"
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
                                                                employee:
                                                                    employee,
                                                                name: 'install',
                                                                installer:
                                                                    installer,
                                                                projectStatus:
                                                                    projectStatus,
                                                                tabName:
                                                                    "Install",
                                                              )),
                                                    ).then((value) {
                                                      if (value == true) {
                                                        setState(() {
                                                          val = true;
                                                          orders.clear();
                                                          addMeasure(
                                                              0,
                                                              installFiltersApplied,
                                                              selectedTeams);
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
    );
  }

  List userData, employee, installer;
  List orders = [];
  bool isFilter = false;
  int selectedRadio;
  String filter;
  List filterStatus = [
    'needs install',
    'install assigned',
    'install incomplete',
    'needs payment',
    'paid'
  ];
  int selectedMeasure, selectedTeam;
  Widget _tabSection(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Stack(
                        children: <Widget>[
                          installFiltersApplied.length > 0
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
                                      "${installFiltersApplied.length}",
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
                                "Install",
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
                          selectedTeams.length > 0
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Expanded(
                child: Container(
                  //Add this to give height
                  // height: MediaQuery.of(context).size.height,
                  child: TabBarView(children: [
                    SingleChildScrollView(
                      child: Container(
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List<Widget>.generate(
                                  filterStatus.length, (int index) {
                                return CheckboxListTile(
                                  title: Text(
                                      '${makeFirstLetterCapital(filterStatus[index])}'),
                                  value: installFilters[index],
                                  onChanged: (val) {
                                    setState(() {
                                      installFilters[index] = val;
                                      if (installFilters[index]) {
                                        installFiltersApplied
                                            .add(filterStatus[index]);
                                      } else {
                                        installFiltersApplied
                                            .remove(filterStatus[index]);
                                      }
                                    });
                                    print(
                                        'install Filters: $installFiltersApplied');
                                  },
                                );
                                // RadioListTile(
                                //   controlAffinity: ListTileControlAffinity.trailing,
                                //   value: index,
                                // title: Text(
                                //     '${makeFirstLetterCapital(filterStatus[index])}'),
                                //   groupValue: selectedMeasure,
                                //   onChanged: (int value) {
                                //     setState(() {
                                //       selectedMeasure = value;
                                //       filter = filterStatus[selectedMeasure];
                                //     });
                                //   },
                                // );
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List<Widget>.generate(teams.length,
                                  (int index) {
                                return CheckboxListTile(
                                  title: Text(
                                      '${makeFirstLetterCapital(teams[index]['name'])}'),
                                  value: availableTeams[index],
                                  onChanged: (val) {
                                    setState(() {
                                      availableTeams[index] = val;
                                      if (availableTeams[index]) {
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
                                //   controlAffinity: ListTileControlAffinity.trailing,
                                //   value: index,
                                // title: Text(
                                //     '${makeFirstLetterCapital(teams[index]['name'])}'),
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
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
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
            height: MediaQuery.of(context).size.height * 0.8,
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

                                  Navigator.of(context).pop();
                                })
                            : FlatButton(
                                onPressed: () {
                                  availableTeams.clear();
                                  for (int i = 0; i < teams.length; i++) {
                                    availableTeams.add(false);
                                  }
                                  print('availalbe teams: $availableTeams');
                                  Navigator.pop(context);
                                  setState(() {
                                    orders.clear();
                                  });
                                  selectedMeasure = null;
                                  selectedTeam = null;

                                  val = true;
                                  isFilter = false;
                                  selectedTeams.clear();
                                  installFiltersApplied.clear();
                                  installFilters = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                  ];
                                  addMeasure(
                                      0, installFiltersApplied, selectedTeams);
                                },
                                child: Text(
                                  'Clear',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 0.0, bottom: 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.6,
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
                                    orders.clear();
                                    val = true;
                                    isFilter = true;
                                    print(filter);
                                    addMeasure(
                                      0,
                                      installFiltersApplied,
                                      selectedTeams,
                                    );
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

  filterPage() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            title: Text('Filter By'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      List<Widget>.generate(filterStatus.length, (int index) {
                    return RadioListTile(
                      value: index,
                      title: Text(
                          '${makeFirstLetterCapital(filterStatus[index])}'),
                      groupValue: selectedRadio,
                      onChanged: (int value) {
                        setState(() {
                          selectedRadio = value;
                        });
                      },
                    );
                  }),
                );
              },
            ),
            actions: <Widget>[
              isFilter == false
                  ? FlatButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        selectedRadio = null;
                        Navigator.of(context).pop();
                      })
                  : FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        orders.clear();
                        selectedRadio = null;
                        val = true;
                        isFilter = false;

                        addMeasure(0, installFiltersApplied, selectedTeams);
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )),
              FlatButton(
                onPressed: () {
                  // Navigator.pop(context, true);
                  setState(() {
                    isFilter = true;
                    addMeasure(0, installFiltersApplied, selectedTeams);
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Filter',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

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
            availableTeams.add(false);
          }
          print('availableTeams $availableTeams');

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
            employee.insert(
                0, {'id': '001', 'name': 'Select Team', 'assigned': false});
            print(employee.length);
            //  print(userData[i]['name']);
          });
        }
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

  changeStatus(String projectId, projectType, status) async {
    print('$status');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
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

  addMeasure(
    int pagenumbercounter,
    List<String> items,
    List<String> assignedTo,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/installprojects';
    if (pagenumbercounter != null) {
      counter = pagenumbercounter;
    }
    print('Page: $counter');
    Map data;
    if (items.isEmpty && assignedTo.isEmpty) {
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
    // if (filt.first != 'all') {
    //   setState(() {
    // orders.clear();
    // val = true;
    //   });
    // }
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
        Map<String, dynamic> data = json.decode(response.body);
        print('install projects: ${data['projectList']}');
        if (mounted) {
          setState(() {
            userData = data['projectList'];
            if (userData.length != 0) {
              for (var i in userData) {
                print(userData.length);
                orders.add(i);
                val = false;
              }
            } else {
              val = false;
            }
          });
        }
      } else {
        print(response.statusCode);
      }
    });
  }
}
