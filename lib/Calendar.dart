import 'dart:convert';
import 'dart:io';
import 'package:aq_admin/Installments.dart';
import 'package:aq_admin/Measurements.dart';
import 'package:aq_admin/fetchProjects.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './custom_search_delegate.dart';
import 'base_url.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class Person {
  final String name, date, phoneno, orderId, projectType;
  Person(this.name, this.date, this.phoneno, this.orderId, this.projectType);
}

class _CalendarScreenState extends State<CalendarScreen> {
  List _selectedEvents = [];
  void _handleNewDate(date) {
    setState(() {
      print(date);
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
      print(_selectedDay);
      // _selectedEvents.add(output);
      print('_selectedEvents: $_selectedEvents');
    });
  }

  List<Color> _colors = [
    Colors.blue,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.grey
  ];
  int i = 0;

  // Map data;
  DateTime _selectedDay;
  List projectStatus = [
    'created',
    'measure assigned',
    'measure incomplete',
    'measure complete',
    'needs estimate',
    'estimated',
    'waiting approval',
    'needs ordering',
    'ordered',
    'waiting',
    'material ready',
    'material arrived',
    'install assigned',
    'install incomplete',
    'needs payment',
    'paid'
  ];

  Map<DateTime, List> _events = Map<DateTime, List>();
  // Map<String, List> ab = {
  //   "2020-11-07 00:00": [
  //     {'name': 'Install', 'Client Name': 'Annette Brooks', 'isDone': false},
  //   ],
  //   "2020-10-30 00:00": [
  //     {'name': 'Measure', 'Client Name': 'Ahmad Edwards', 'isDone': true},
  //     {'name': 'Install', 'Client Name': 'Annette Brooks', 'isDone': false},
  //   ],
  //   "2020-10-09 00:00": [
  //     {'name': 'Measure', 'Client Name': 'Mike Smith', 'isDone': true},
  //   ],
  // };
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scaffoldKey
        .currentState
        .showSnackBar(SnackBar(content: Text('Loading...'))));
    print('1');
    Future.wait([getData(), addEmployee()]);
    print('3');
    // await getData();
    // await addEmployee();
    // getProject();
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Calendar Events'),
        backgroundColor: Color(0xff44aae4),
        actions: <Widget>[
          // Using Stack to show Notification Badge
          IconButton(
            tooltip: 'Search Project',
            icon: Icon(Icons.search),
            onPressed: _events.isEmpty
                ? null
                : () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                          _events, employee, projectStatus, installer),
                    );
                  },
          ),
          // new IconButton(
          //   icon: Icon(
          //     Icons.search,
          //     size: 25,
          //   ),
          //   tooltip: 'Search people',
          //   onPressed: () => showSearch(
          //     context: context,
          //     delegate: SearchPage<FetchProject>(
          //         items: fetchProject,
          //         searchLabel: 'Search Clients',
          //         suggestion: Center(
          //           child: Text(
          //               'Filter Orders by Client name, Date or Project Type'),
          //         ),
          //         failure: Center(
          //           child: Text('No Client found :('),
          //         ),
          //         filter: (fetchProject) {
          //           var parsedDate = DateTime.parse(fetchProject.date);
          //           var formatter = new DateFormat.yMd();
          //           String formattedDate = formatter.format(parsedDate);
          //           return [
          //             fetchProject.firstname,
          //             fetchProject.lastname,
          //             fetchProject.projecttype,
          //             formattedDate
          //           ];
          //         },
          //         builder: (fetchProject) {
          //           var parsedDate = DateTime.parse(fetchProject.date);
          //           var formatter = new DateFormat.yMMMd();
          //           String formattedDate = formatter.format(parsedDate);

          //           return Container(
          //             child: Card(
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.max,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: <Widget>[
          //                   ListTile(
          //                     // onLongPress: () {
          //                     //   setState(() {
          //                     //     this.people.removeAt(index);
          //                     //     Scaffold.of(context).showSnackBar(
          //                     //       SnackBar(
          //                     //         content: Text(
          //                     //           'Project Moved to Scheduled List',
          //                     //         ),
          //                     //         action: SnackBarAction(
          //                     //           label: 'UNDO',
          //                     //           onPressed: () {
          //                     //             setState(() {
          //                     //               this.people.insert(index, person);

          //                     //               // userlist.removeAt(i);
          //                     //             });
          //                     //           },
          //                     //         ),
          //                     //       ),
          //                     //     );
          //                     //   });
          //                     // },
          //                     onTap: () {
          //                       if (fetchProject.projecttype == "measure") {
          //                         // Navigator.push(
          //                         //   context,
          //                         //   MaterialPageRoute(
          //                         //     builder: (context) => Measurements(
          //                         //       id: fetchProject.id
          //                         //     ),
          //                         //   ),
          //                         // );
          //                       } else {
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                             builder: (context) => Installments(
          //                               id: fetchProject.id,
          //                             ),
          //                           ),
          //                         );
          //                       }
          //                     },
          //                     leading: Icon(Icons.adjust, color: Colors.green),
          //                     title: Text(
          //                       'Project Type : ${fetchProject.projecttype.toString().toUpperCase()}',
          //                       style: TextStyle(fontSize: 15),
          //                     ),
          //                     subtitle: Text(
          //                       'Client Name : ${fetchProject.firstname} ${fetchProject.lastname}',
          //                     ),
          //                     trailing: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: <Widget>[
          //                         Text(formattedDate),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           );
          //         }),
          //   ),
          // ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              child: Calendar(
                startOnMonday: true,
                weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                events: _events,
                onRangeSelected: (range) =>
                    print("Range is ${range.from}, ${range.to}"),
                onDateSelected: (date) => _handleNewDate(date),
                isExpandable: true,
                isExpanded: true,
                eventDoneColor: Colors.yellow,
                selectedColor: Colors.pink,
                todayColor: Color(0xff44aae4),
                eventColor: Colors.blue,
                dayOfWeekStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 11),
              ),
            ),
            _buildEventList()
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _selectedEvents == null ? 0 : _selectedEvents.length,
        itemBuilder: (context, index) {
          if (_selectedEvents[index]['taskStatus'] == "incomplete") {
            i = 2;
          } else if (_selectedEvents[index]['taskStatus'] == "completed") {
            i = 0;
          } else if (_selectedEvents[index]['taskStatus'] == "assigned") {
            i = 1;
          } else if (_selectedEvents[index]['taskStatus'] == "paid") {
            i = 3;
          } else {
            i = 4;
          }
          if (_selectedEvents[index]['taskStatus'] == "incomplete") {
            i = 2;
          }
          return Container(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    // onLongPress: () {
                    //   setState(() {
                    //     this.people.removeAt(index);
                    //     Scaffold.of(context).showSnackBar(
                    //       SnackBar(
                    //         content: Text(
                    //           'Project Moved to Scheduled List',
                    //         ),
                    //         action: SnackBarAction(
                    //           label: 'UNDO',
                    //           onPressed: () {
                    //             setState(() {
                    //               this.people.insert(index, person);

                    //               // userlist.removeAt(i);
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     );
                    //   });
                    // },
                    onTap: () {
                      if (_selectedEvents[index]['projectType'] == "measure") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Measurements(
                              id: _selectedEvents[index]['projectId'],
                              employee: employee,
                              projectStatus: projectStatus,
                              name: 'measure',
                              installer: installer,
                              tabName: "Measure",
                            ),
                          ),
                        );
                      } else if (_selectedEvents[index]['projectType'] ==
                          "install") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Measurements(
                              id: _selectedEvents[index]['projectId'],
                              employee: employee,
                              projectStatus: projectStatus,
                              name: 'install',
                              installer: installer,
                              tabName: "Install",
                            ),
                          ),
                        );
                      }
                    },
                    leading: _selectedEvents[index]['taskStatus'] == 'completed' ||
                            _selectedEvents[index]['taskStatus'] ==
                                'measure complete'
                        ? Container(
                            height: 30,
                            width: 50,
                            child: Image.asset(
                              'lib/assets/Needs_Estimate.png',
                            ),
                          )
                        : _selectedEvents[index]['taskStatus'] ==
                                'install incomplete'
                            ? Container(
                                height: 30,
                                width: 50,
                                child: Image.asset(
                                  'lib/assets/install_incomplete.png',
                                ),
                              )
                            : _selectedEvents[index]['taskStatus'] ==
                                    'needs estimate'
                                ? Container(
                                    height: 30,
                                    width: 50,
                                    child: Image.asset(
                                      'lib/assets/Needs_Estimate.png',
                                    ),
                                  )
                                : _selectedEvents[index]['taskStatus'] ==
                                        'needs install'
                                    ? Container(
                                        height: 30,
                                        width: 50,
                                        child: Image.asset(
                                          'lib/assets/Needs_Install.png',
                                        ),
                                      )
                                    : _selectedEvents[index]['taskStatus'] ==
                                                'assigned' ||
                                            _selectedEvents[index]
                                                    ['taskStatus'] ==
                                                'measure assigned'
                                        ? Container(
                                            height: 30,
                                            width: 50,
                                            child: Image.asset(
                                              'lib/assets/Measure_assigned.png',
                                            ),
                                          )
                                        : _selectedEvents[index]
                                                    ['taskStatus'] ==
                                                'estimate dormant'
                                            ? Container(
                                                height: 30,
                                                width: 50,
                                                child: Image.asset(
                                                  'lib/assets/estimate_dormant.png',
                                                ),
                                              )
                                            : _selectedEvents[index]
                                                        ['taskStatus'] ==
                                                    'install assigned'
                                                ? Container(
                                                    height: 30,
                                                    width: 50,
                                                    child: Image.asset(
                                                      'lib/assets/install_assigned.png',
                                                    ),
                                                  )
                                                : _selectedEvents[index]
                                                            ['taskStatus'] ==
                                                        'measure incomplete'
                                                    ? Container(
                                                        height: 30,
                                                        width: 50,
                                                        child: Image.asset(
                                                          'lib/assets/Measure_incomplete.png',
                                                        ),
                                                      )
                                                    : _selectedEvents[index]['taskStatus'] ==
                                                            'waiting approval'
                                                        ? Container(
                                                            height: 30,
                                                            width: 50,
                                                            child: Image.asset(
                                                              'lib/assets/Waiting_Approval.png',
                                                            ),
                                                          )
                                                        : _selectedEvents[index]
                                                                    ['taskStatus'] ==
                                                                'incomplete'
                                                            ? Container(
                                                                height: 30,
                                                                width: 50,
                                                                child:
                                                                    Image.asset(
                                                                  'lib/assets/install_incomplete.png',
                                                                ),
                                                              )
                                                            : _selectedEvents[index]['taskStatus'] == 'paid' || _selectedEvents[index]['taskStatus'] == null
                                                                ? Container(
                                                                    height: 30,
                                                                    width: 50,
                                                                    child: Image
                                                                        .asset(
                                                                      'lib/assets/Paid.png',
                                                                    ),
                                                                  )
                                                                : _selectedEvents[index]['taskStatus'] == 'created'
                                                                    ? Container(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            50,
                                                                        child: Image
                                                                            .asset(
                                                                          'lib/assets/Measure_Created.png',
                                                                        ),
                                                                      )
                                                                    : _selectedEvents[index]['taskStatus'] == 'estimate rejected'
                                                                        ? Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                50,
                                                                            child:
                                                                                Image.asset(
                                                                              'lib/assets/estimate_rejected.png',
                                                                            ),
                                                                          )
                                                                        : _selectedEvents[index]['taskStatus'] == 'needs ordering'
                                                                            ? Container(
                                                                                height: 30,
                                                                                width: 50,
                                                                                child: Image.asset(
                                                                                  'lib/assets/needs_ordering.png',
                                                                                ),
                                                                              )
                                                                            : _selectedEvents[index]['taskStatus'] == 'waiting delivery' || _selectedEvents[index]['taskStatus'] == 'ordered' || _selectedEvents[index]['taskStatus'] == 'waiting'
                                                                                ? Container(
                                                                                    height: 30,
                                                                                    width: 50,
                                                                                    child: Image.asset(
                                                                                      'lib/assets/waiting_delivery.png',
                                                                                    ),
                                                                                  )
                                                                                : _selectedEvents[index]['taskStatus'] == 'needs payment'
                                                                                    ? Container(
                                                                                        height: 30,
                                                                                        width: 50,
                                                                                        child: Image.asset(
                                                                                          'lib/assets/Needs_payment.png',
                                                                                        ),
                                                                                      )
                                                                                    : _selectedEvents[index]['taskStatus'] == 'material ready'
                                                                                        ? Container(
                                                                                            height: 30,
                                                                                            width: 50,
                                                                                            child: Image.asset(
                                                                                              'lib/assets/Material_ready.png',
                                                                                            ),
                                                                                          )
                                                                                        : _selectedEvents[index]['taskStatus'] == 'estimated'
                                                                                            ? Container(
                                                                                                height: 30,
                                                                                                width: 50,
                                                                                                child: Image.asset(
                                                                                                  'lib/assets/estimated.png',
                                                                                                ),
                                                                                              )
                                                                                            : _selectedEvents[index]['taskStatus'] == 'material arrived'
                                                                                                ? Container(
                                                                                                    height: 30,
                                                                                                    width: 50,
                                                                                                    child: Image.asset(
                                                                                                      'lib/assets/material_arrived.png',
                                                                                                    ),
                                                                                                  )
                                                                                                : Container(
                                                                                                    height: 30,
                                                                                                    width: 50,
                                                                                                    child: Image.asset(
                                                                                                      'lib/assets/unknown.png',
                                                                                                    ),
                                                                                                  ),

                    // Icon(
                    //   Icons.adjust,
                    //   color: _colors[i],
                    // ),

                    // title: Text(
                    //     'Project Type : ${_selectedEvents[index]['projectType'].toString().toUpperCase()}'),
                    // subtitle: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    title: Text(
                      _selectedEvents[index]['clientName'].toString() == ' ' ||
                              _selectedEvents[index]['clientName'].toString() ==
                                  ''
                          ? '${_selectedEvents[index]['clientAddress']}'
                          : '${_selectedEvents[index]['clientName'].toString()}',
                    ),
                    subtitle: Text(
                        'Address: ${_selectedEvents[index]['clientAddress']}'),
                    trailing: Text(
                        '${_selectedEvents[index]['time'].toString().substring(11, 19)}'),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 5.0,
                    //     horizontal: 10.0,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     // color: Colors.amber,
                    //     color: _colors[i],
                    //     borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(10),
                    //         bottomRight: Radius.circular(10)),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       "${_selectedEvents[index]['taskStatus']}",
                    //       // "${toBeginningOfSentenceCase(projectStatus[i])}",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 12,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //   ],
                    // ),

                    // trailing: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Text("${_selectedEvents[index]['name'].toString()}"),
                    //   ],
                    // ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  var output;
  Map<DateTime, List<dynamic>> map1;
  List items = [];

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print('token: $token');
    http.Response response = await http.get(
        '${ApiBaseUrl.BASE_URL}/restapi/admin/appcalendar',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print("calendar events output: $map");
      Map<String, List> myMaps = Map<String, List>.from(map['calendar']);
      var output = myMaps.map((key, value) {
        return MapEntry(DateTime.parse(key), value);
      });
      myMaps.clear();
      setState(() {
        // String ab = 'Swapnil+00:00';
        _events.addAll(output);
        // print("calendar events output: $_events");
      });

      // myMaps.forEach((key, value) {
      //   // map1.addAll({DateTime.parse(key): value});
      //   print(map1);
      // });
      // for (var i in myMaps.entries) {
      //   var map=i.map((key, value) {
      // //   return MapEntry(DateTime.parse(key), value);
      // // });
      // }
      // print(items[0]);
      // map1.addAll(output);
      // if (output != null || output.length != 0) {
      //   setState(() {
      //     // _events = output;
      //     // print(_events);
      //   });
      // } else {
      //   print('null');
      // }
    } else {
      print(response.statusCode);
    }
  }

  // var project;
  // List<FetchProject> fetchProject;
  // Future getProject() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString("token");
  //   http.Response response = await http.get(
  //       '${ApiBaseUrl.BASE_URL}/restapi/user/project',
  //       headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
  //   print(response.statusCode);
  //   project = json.decode(response.body);
  //   setState(() {
  //     var list = project["projects"] as List;
  //     fetchProject = list.map((data) => FetchProject.fromJson(data)).toList();
  //     print(fetchProject[0].firstname);
  //   });
  // }
  List employee, installer;
  Future<void> addEmployee() async {
    print('2');
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
                0, {'id': '001', 'name': 'select employee', 'assigned': false});
            print(installer);
            //  print(userData[i]['name']);
          });
        }
      } else {
        print(response.statusCode);
      }
    });
  }
}
