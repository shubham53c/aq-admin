import 'dart:convert';
import 'dart:io';
import '../CapitalText.dart';
import 'package:aq_admin/Measurements.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../base_url.dart';
import '../search_project_delegate.dart';

class ArchivedProjects extends StatefulWidget {
  @override
  _ArchivedProjectsState createState() => _ArchivedProjectsState();
}

class _ArchivedProjectsState extends State<ArchivedProjects> {
  String _selectedId, changedStatus;
  DateFormat timeformat = DateFormat.jm();

  List status = [
    'created',
    'measure assigned',
    'measure incomplete',
    'needs estimate',
    'waiting approval',
    'estimate dormant',
    'estimate rejected',
    'needs ordering',
    'waiting delivery',
    'needs install',
    'install assigned',
    'install incomplete',
    'needs payment',
    'paid'
  ];
  String assignedid, name;

  List<Color> _colors = [
    Colors.orange,
    Colors.red,
    Colors.brown,
    Colors.green,
    Colors.blue
  ];

  static const menuItems = <String>['View Details', 'Unarchive'];
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
  void incrementCounter() {
    setState(() {
      counter = counter + 1;
      // print(counter);
      // allChats(messege: '$counter');
      addMeasure(counter);
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
    try {
      addMeasure(0);
    } on SocketException {
      print('error');
    }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          "Archive Projects",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            tooltip: 'Search Project',
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    CustomSearchDelegate(employee, projectStatus, installer),
              );
            },
          ),
        ],
        // actions: <Widget>[
        // Using Stack to show Notification Badg
        // Stack(children: <Widget>[
        // IconButton(
        //     icon: Icon(Icons.filter_list),
        //     onPressed: () {
        //       // filterPage();
        //       modalSheet();
        //     }),
        // isFilter == true
        //     ? Positioned(
        //         right: 11,
        //         top: 11,
        //         child: new Container(
        //           padding: EdgeInsets.all(2),
        //           decoration: new BoxDecoration(
        //             color: Colors.red,
        //             borderRadius: BorderRadius.circular(6),
        //           ),
        //           constraints: BoxConstraints(
        //             minWidth: 14,
        //             minHeight: 14,
        //           ),
        //           child: Text(
        //             "1",
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 8,
        //             ),
        //             textAlign: TextAlign.center,
        //           ),
        //         ),
        //       )
        //     : SizedBox()
        //: new Container()
        // ]),
        // ],
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
                addMeasure(0);
                await Future.delayed(Duration(seconds: 2));
                _refreshController.refreshCompleted();
              },
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: listScrollController,
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
                                          tabName: projectType == 'measure'
                                              ? "Measure"
                                              : "Install",
                                        )),
                              ).then((value) {
                                if (value == true) {
                                  setState(() {
                                    val = true;
                                    orders.clear();
                                    addMeasure(0);
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
                                      border: makeFirstLetterCapital(orders[index]
                                                  ['projectstatus']) ==
                                              'Estimate Rejected'
                                          ? Border.all(
                                              color: Colors.red,
                                              width: 2,
                                            )
                                          : makeFirstLetterCapital(orders[index]
                                                      ['projectstatus']) ==
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
                                                          color: _colors[i],
                                                          width: 2),
                                                      left: BorderSide(
                                                          color: _colors[i],
                                                          width: 2),
                                                      bottom: BorderSide(
                                                          color: _colors[i],
                                                          width: 2),
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
                                              child: icon == null
                                                  ? SizedBox()
                                                  : Image.asset(icon)),
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
                                                      addMeasure(0);
                                                    });
                                                  } else {
                                                    print(value);
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
                                                      title: Text('Warning !'),
                                                      content: Text(
                                                          'Following invoice will be remove From Archive'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          onPressed: () {
                                                            // Navigator.pop(context, false);
                                                            Navigator.of(
                                                              context,
                                                              // rootNavigator: true,
                                                            ).pop(false);
                                                          },
                                                          child: Text('Cancel',
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
                                                            'Continue',
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
                                                  color: makeFirstLetterCapital(
                                                              orders[index][
                                                                  'projectstatus']) ==
                                                          'Estimate Dormant'
                                                      ? Colors.brown
                                                      : makeFirstLetterCapital(
                                                                  orders[index][
                                                                      'projectstatus']) ==
                                                              'Estimate Rejected'
                                                          ? Colors.red
                                                          : makeFirstLetterCapital(
                                                                      orders[index]
                                                                          [
                                                                          'projectstatus']) ==
                                                                  'Paid'
                                                              ? Colors.green
                                                              : _colors[i],
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
                                                          addMeasure(0);
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

  String _btn3SelectedVal, id;

  List userData, installer;
  List employee = [];
  bool isFilter = false;
  List orders = [];
  int selectedMeasure, selectedOrders, selectedInstall, selectedTeam;
  List measureFilter = ['created', 'measure assigned', 'measure incomplete'];
  List orderFilter = [
    'needs estimate',
    'waiting approval',
    'estimate dormant',
    'estimate rejected',
    'needs ordering',
    'waiting delivery'
  ];
  List installFilter = [
    'needs install',
    'install assigned',
    'install incomplete',
    'needs payment',
    'paid'
  ];

  String filterStatus;
  int employee1;
//   Widget _tabSection(BuildContext context) {
//   return DefaultTabController(
//     length: 4,
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Container(
//           child: TabBar(
//             tabs: [
//                Tab(
//                   child: Stack(children: <Widget>[
//                  selectedMeasure!=null?Positioned(
//                     right: 10,
//                     top:2,
//                     child: new Container(
//                       padding: EdgeInsets.all(2),
//                       decoration: new BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       constraints: BoxConstraints(
//                         minWidth: 14,
//                         minHeight: 10,
//                       ),
//                       child: Text(
//                         "1",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 8,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ):SizedBox(),
//                                Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           border: Border.all(color: Color(0xff44aae4), width: 1)),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text("Measure",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
//                       ),
//                     ),

//                   ],

//                   ),
//                 ),
//              Tab(
//                   child: Stack(children: <Widget>[
//                      selectedOrders!=null?Positioned(
//                     right: 10,
//                     top:2,
//                     child: new Container(
//                       padding: EdgeInsets.all(2),
//                       decoration: new BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       constraints: BoxConstraints(
//                         minWidth: 14,
//                         minHeight: 10,
//                       ),
//                       child: Text(
//                         "1",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 8,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ):SizedBox(),
//                                Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           border: Border.all(color: Color(0xff44aae4), width: 1)),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text("Orders",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
//                       ),
//                     ),

//                   ],

//                   ),
//                 ),
//             Tab(
//              child: Stack(children: <Widget>[
//                selectedInstall!=null?Positioned(
//                     right: 10,
//                     top:2,
//                     child: new Container(
//                       padding: EdgeInsets.all(2),
//                       decoration: new BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       constraints: BoxConstraints(
//                         minWidth: 14,
//                         minHeight: 10,
//                       ),
//                       child: Text(
//                         "1",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 8,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ):SizedBox(),
// Container(decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           border: Border.all(color: Color(0xff44aae4), width: 1)),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text("Install",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//              ],

//              ),
//                 ),
//                  Tab(
//                   child: Stack(children: <Widget>[
//                     selectedTeam!=null?Positioned(
//                     right: 10,
//                     top:2,
//                     child: new Container(
//                       padding: EdgeInsets.all(2),
//                       decoration: new BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       constraints: BoxConstraints(
//                         minWidth: 14,
//                         minHeight: 10,
//                       ),
//                       child: Text(
//                         "1",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 8,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ):SizedBox(),
//                     Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           border: Border.all(color: Color(0xff44aae4), width: 1)),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text("Teams",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                   ],

//                   ),
//                 ),
//           ],onTap:(tabIndex) {
//                               if (tabIndex == 0) {
//                                 if (isFilter == false) {
//                                   selectedMeasure = null;
//                                   selectedInstall = null;
//                                   selectedOrders = null;
//                                 } else {
//                                   if (measureFilter.contains(filterStatus)) {
//                                     selectedInstall = null;
//                                     selectedOrders = null;
//                                   }
//                                 }
//                               } else if (tabIndex == 1) {
//                                 if (isFilter == false) {
//                                   selectedMeasure = null;
//                                   selectedInstall = null;
//                                   selectedOrders = null;
//                                 }else{
//                                    if (orderFilter.contains(filterStatus)) {
//                                     selectedInstall = null;
//                                     selectedMeasure = null;
//                                   }
//                                 }
//                               } else if (tabIndex == 2) {
//                                 if (isFilter == false) {
//                                   selectedMeasure = null;
//                                   selectedInstall = null;
//                                   selectedOrders = null;
//                                 }else{
//                                    if (installFilter.contains(filterStatus)) {
//                                     selectedOrders = null;
//                                     selectedMeasure = null;
//                                   }
//                               }
//                             }},
//            unselectedLabelColor: Color(0xff44aae4),
//               indicatorSize: TabBarIndicatorSize.label,
//               indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   color:Color(0xff44aae4)),
//           ),
//         ),

//         Expanded(
//                   child: Container(
//             //Add this to give height
//             // height: MediaQuery.of(context).size.height,
//             child: TabBarView(children: [
//       Container(
//                                   child: StatefulBuilder(
//                                     builder: (BuildContext context,
//                                         StateSetter setState) {
//                                       return Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: List<Widget>.generate(
//                                             measureFilter.length, (int index) {
//                                           return RadioListTile(controlAffinity: ListTileControlAffinity.trailing,
//                                             value: index,
//                                             title: Text(
//                                                 '${makeFirstLetterCapital(measureFilter[index])}'),
//                                             groupValue: selectedMeasure,
//                                             onChanged: (int value) {
//                                               setState(() {
//                                                 selectedMeasure = value;
//                                                 filterStatus = measureFilter[
//                                                     selectedMeasure];
//                                               });
//                                             },
//                                           );
//                                         }),
//                                       );
//                                     },
//                                   ),
//                                 ),

//              SingleChildScrollView(
//                             child: Center(
//                               child: Container(
//                                     child: StatefulBuilder(
//                                       builder: (BuildContext context,
//                                           StateSetter setState) {
//                                         return Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: List<Widget>.generate(
//                                               orderFilter.length, (int index) {
//                                             return Padding(
//                                               padding: const EdgeInsets.all(0),
//                                               child: RadioListTile(controlAffinity: ListTileControlAffinity.trailing,
//                                                 value: index,
//                                                 title: Text(
//                                                     '${makeFirstLetterCapital(orderFilter[index])}'),
//                                                 groupValue: selectedOrders,
//                                                 onChanged: (int value) {
//                                                   setState(() {
//                                                     selectedOrders = value;
//                                                     filterStatus =
//                                                         orderFilter[selectedOrders];
//                                                   });
//                                                 },
//                                               ),
//                                             );
//                                           }),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                             ),
//              ),
//                 Container(
//                                   child: StatefulBuilder(
//                                     builder: (BuildContext context,
//                                         StateSetter setState) {
//                                       return Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: List<Widget>.generate(
//                                             installFilter.length, (int index) {
//                                           return RadioListTile(controlAffinity: ListTileControlAffinity.trailing,
//                                             value: index,
//                                             title: Text(
//                                                 '${makeFirstLetterCapital(installFilter[index])}'),
//                                             groupValue: selectedInstall,
//                                             onChanged: (int value) {
//                                               setState(() {
//                                                 selectedInstall = value;
//                                                 filterStatus = installFilter[selectedInstall];
//                                               });
//                                             },
//                                           );
//                                         }),
//                                       );
//                                     },
//                                   ),
//                                 ),

//               //   SingleChildScrollView(
//               //                     child: Center(
//               //      child: Container(
//               //                       child: StatefulBuilder(
//               //                         builder: (BuildContext context,
//               //                             StateSetter setState) {
//               //                           return Column(
//               //                             mainAxisSize: MainAxisSize.min,
//               //                             children: List<Widget>.generate(
//               //                                 teams.length, (int index) {
//               //                               return RadioListTile(controlAffinity: ListTileControlAffinity.trailing,
//               //                                 value: index,
//               //                                 title: Text(
//               //                                     '${makeFirstLetterCapital(teams[index]['name'])}'),
//               //                                 groupValue: selectedTeam,
//               //                                 onChanged: (int value) {
//               //                                   setState(() {
//               //                                    selectedTeam  = value;
//               //                                    id=teams[index]['id'];

//               //                                   //  print(employee1);
//               //                                     // filterStatus = installFilter[selectedInstall];
//               //                                   });
//               //                                 },
//               //                               );
//               //                             }),
//               //                           );
//               //                         },
//               //                       ),
//               //                     ),
//               //  ),
//               //   )

//             ]),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//   modalSheet() {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
//         ),
//         builder: (context) {
//           return Container(
//             height: MediaQuery.of(context).size.height * 0.8,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                     padding: EdgeInsets.only(right: 10, left: 10),
//                     height: MediaQuery.of(context).size.height * 0.1,
//                     child: Row(
//                       children: <Widget>[
//                         Text(
//                           'Filters',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Spacer(),
//                         isFilter == false
//                             ? FlatButton(
//                                 child: Text(
//                                   'Cancel',
//                                   style: TextStyle(
//                                       color: Colors.red,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 onPressed: () {
//                                   selectedMeasure = null;
//                                   selectedInstall = null;
//                                   selectedOrders = null;
//                                   selectedTeam=null;
//                                    id=null;
//                                   Navigator.of(context).pop();
//                                 })
//                             : FlatButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   orders.clear();
//                                   selectedMeasure = null;
//                                   selectedInstall = null;
//                                   selectedOrders = null;
//                                   selectedTeam=null;
//                                   id=null;
//                                   val = true;
//                                   isFilter = false;
//                                   addMeasure(0,'all',id);
//                                 },
//                                 child: Text(
//                                   'Clear',
//                                   style: TextStyle(
//                                       color: Colors.red,
//                                       fontWeight: FontWeight.bold),
//                                 )),
//                       ],
//                     )),
//                 Padding(
//                   padding: EdgeInsets.only(
//                      top: 0.0, bottom: 8.0),
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.all(10),
//                         height: MediaQuery.of(context).size.height * 0.6,
//                        child: _tabSection(context),

//                       ),
//                       Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                               width: 150,
//                               margin: EdgeInsets.all(4),
//                               child: new RaisedButton(
//                                 child: new Text("Apply"),
//                                 textColor: Colors.white,
//                                 color: Color(0xff44aae4),
//                                 onPressed: () {
//                                   Set<dynamic> tempData;
//                                   setState(() {
// //                                var uniqueIds = employee.map((o) {
// //                                  tempData = o.toSet();
// //                                  print('tempDAta $tempData');
// //                                }).toSet();
// //                                print(uniqueIds);
// //                                         for(var i in employee){
// // var selected =i['name'].toSet().toList();
// // print('bbvcsdczbdjkvcsdkjz $selected');
// // }
//                                     isFilter = true;
//                                     print(id);
//                                     addMeasure(0, filterStatus,id);
//                                     Navigator.pop(context);
//                                   });
//                                 },
//                                 shape: new RoundedRectangleBorder(
//                                     borderRadius:
//                                         new BorderRadius.circular(2.0)),
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         });
//   }

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
  //                     List<Widget>.generate(measureFilter.length, (int index) {
  //                   return RadioListTile(
  //               value: index,
  //                     title: Text(
  //                         '${makeFirstLetterCapital(measureFilter[index])}'),
  //                     groupValue: selectedRadio,
  //                     onChanged: (int value) {
  //                       setState(() {
  //                         selectedRadio = value;
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
  //                       addMeasure(0, 'all');
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
  //                   addMeasure(0, measureFilter[selectedRadio]);
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
  // List<Map<String, dynamic>> teams = [];
  //   addEmployee() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString("token");
  //   String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/inspectionandmeasurerusers';
  //   try{await http.post(
  //     url,
  //     headers: {
  //       "content-type": "application/json",
  //       "accept": "application/json",
  //       HttpHeaders.authorizationHeader: 'Bearer $token'
  //     },
  //   ).then((response) {
  //     if (response.statusCode == 200) {
  //    Map<String, dynamic> loginData = json.decode(response.body);
  //       //  userData=loginData;
  //          List<Map<String, dynamic>> emp = List<Map<String, dynamic>>.from(loginData['inspectors']);
  //         //  emp.insert(0,{'id':'001','name':'Select Team','assigned':false});
  //         print('emp $emp');

  //         List<String> uniqueIds = [];
  //         emp.map((o) {
  //           print('o $o');
  //           if(!uniqueIds.contains(o['id'])){
  //                          uniqueIds.add(o['id']);
  //                        }
  //                              }).toList();
  //         print('unq $uniqueIds');
  //         for(int i =0; i < uniqueIds.length; i++){
  //           var temp12 = emp.firstWhere((element) {
  //             return element['id'] == uniqueIds[i];
  //           });
  //           teams.add(temp12);
  //         }

  //         // print('temp1 $temp1');

  //     } else {
  //       print(response.statusCode);
  //     }
  //   });}catch(e){
  //     print('e $e');
  //   }
  // }
  deleteProject(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print(id);
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
          setState(() {
            print(response.statusCode);
            Fluttertoast.showToast(
                msg: "Unarchive",
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

  addMeasure(int pagenumbercounter) async {
    print(pagenumbercounter);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/archived';
    Map data = {
      "projectStatus": "all",
      "recordPerPage": 10,
      "pageNumber": pagenumbercounter
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
        print(response.statusCode);
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
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
          print('A network error occurred');
          throw Exception('A network error occurred');
        }
      });
    } catch (e) {
      print('$e');
    }
  }
}
