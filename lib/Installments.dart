// import 'package:aq_admin/Information.dart';
// import 'package:aq_admin/OrderDetails.dart';
// import 'package:flutter/material.dart';


// class Installments extends StatefulWidget {
//   final String id;

//   Installments({@required this.id});
//   @override
//   _InstallmentsState createState() => _InstallmentsState();
// }

// class _InstallmentsState extends State<Installments>
//     with TickerProviderStateMixin {
//   TabController tabController;
//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 2, vsync: this);
//   }

//   changeMyTab() {
//     setState(() {
//       tabController.index = 1;
//     });
//   }

//   int _currentValue = 1;
//   setEndPressed(int value) {
//     setState(() {
//       _currentValue = value;
//     });
//   }

//   int i = 0;

//   bool paid = false;
//   List<Color> _colors = [Colors.grey[200], Colors.red, Color(0xff44aae4)];

//   // Future<bool> _onBackPressed() {
//   //   return _onback();
//   // }

//   // Future _onback() async {
//   //   setState(() {
//   //     Navigator.pop(context, true);
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color(0xff44aae4),
//             title: Text(
//               'Install',
//               style: TextStyle(fontSize: 18),
//             ),
//             bottom: TabBar(
//               indicatorColor: Colors.white,
//               controller: tabController,
//               tabs: <Widget>[
//                 Tab(
//                   child: Text(
//                     'Information',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 Tab(
//                   child: Text(
//                     'Glass Details',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: TabBarView(controller: tabController, children: <Widget>[
//             Information(
//               id: widget.id,
//               // onTabChangeCallback: () => {changeMyTab()},
//             ),
//             OrderDetails(
//               id: widget.id,
//             ),
//           ]),
//           // floatingActionButton: FloatingActionRow(
//           //   color: Colors.blueAccent,
//           //   children: <Widget>[
//           //     FloatingActionRowButton(
//           //         icon: Icon(FontAwesomeIcons.uncharted), onTap: () {}),
//           //     FloatingActionRowDivider(),
//           //     FloatingActionRowButton(
//           //         icon: Icon(Icons.arrow_forward), onTap: () {}),
//           //   ],
//           // ),
//           // bottomNavigationBar: new Container(
//           //   color: Colors.white.withOpacity(1),
//           //   padding: EdgeInsets.all(5),
//           //   child: Row(
//           //     children: <Widget>[
//           //       Expanded(
//           //           flex: 1,
//           //           child: StepProgressIndicator(
//           //             totalSteps: 3,
//           //             currentStep: _currentValue,
//           //             size: 25,
//           //             selectedColor: Color(0xff44aae4),
//           //             unselectedColor: Color(0xff69737f),
//           //             customColor: (index) => index == 0
//           //                 ? Colors.yellow
//           //                 : index == 2
//           //                     ? paid ? Colors.green : Colors.grey[200]
//           //                     : _colors[i],
//           //             customStep: (index, color, _) => index == 0
//           //                 ? Container(
//           //                     color: color,
//           //                     // child: Center(
//           //                     //     child: Row(
//           //                     //   crossAxisAlignment: CrossAxisAlignment.center,
//           //                     //   mainAxisAlignment: MainAxisAlignment.center,
//           //                     //   children: <Widget>[

//           //                     // Icon(
//           //                     //   Icons.check,
//           //                     //   color: Colors.white,
//           //                     // ),
//           //                     // Text(
//           //                     //   "Assigned",
//           //                     //   style: TextStyle(color: Colors.white),
//           //                     // ),
//           //                     //   ],
//           //                     // )),
//           //                   )
//           //                 : Container(
//           //                     color: color,

//           //                     // child: Center(
//           //                     //     child: Row(
//           //                     //   crossAxisAlignment: CrossAxisAlignment.center,
//           //                     //   mainAxisAlignment: MainAxisAlignment.center,
//           //                     //   children: <Widget>[
//           //                     //     val
//           //                     //         ? Icon(Icons.check, color: Colors.white)
//           //                     //         : Center(
//           //                     //             child: Icon(Icons.remove,
//           //                     //                 color: Colors.white)),
//           //                     //     val
//           //                     //         ? Text(
//           //                     //             text,
//           //                     //             style: TextStyle(color: Colors.white),
//           //                     //           )
//           //                     //         : SizedBox(),
//           //                     //   ],
//           //                     // )),
//           //                   ),
//           //           )),
//           //     ],
//           //   ),
//           // ),
//          );
//   }
// }
