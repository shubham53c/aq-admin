// import 'dart:convert';
// import 'dart:io';
// import 'package:aq_admin/Invoice.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:maps_launcher/maps_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Information extends StatefulWidget {
//   final String id;
//   Information({@required this.id});
//   // const Information({this.onTabChangeCallback});
//   // final TabChangeCallback onTabChangeCallback;
//   //onTabChangeCallback
//   @override
//   _InformationState createState() => _InformationState();
// }

// class _InformationState extends State<Information> {
//   // TabChangeCallback onTabChangeCallback;

//   // _InformationState(TabChangeCallback onTabChangeCallback) {
//   //   this.onTabChangeCallback = onTabChangeCallback;
//   // }
//   int _currentValue = 1;
//   setEndPressed(int value) {
//     setState(() {
//       _currentValue = value;
//     });
//   }

//   Map data;

//   @override
//   void initState() {
//     super.initState();
//      getData();
//   }

//   String name, address, email, phone;
//   int i = 0;
//   List<Color> _colors = [Colors.grey[200], Colors.red, Color(0xff44aae4)];
//   bool val1 = false;
//   bool val = false;
//   bool paid = false;
//   final _text = TextEditingController();
//   bool _validate = false;

//   String text = 'incomplete';
//   @override
//   Widget build(BuildContext context) {
//     Future<void> _launched;
//     String _phone = '';

//     Future<void> _makePhoneCall(String url) async {
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//     }

//     final Uri _emailLaunchUri = Uri(
//         scheme: 'mailto',
//         path: email,
//         queryParameters: {'subject': 'AqGlass'});

//     return Scaffold(
//       backgroundColor: Color(0xfff7f7f7),
//       body:
//           data == null || data.length == 0
//               ? Center(child: CircularProgressIndicator())
//               :
//           Stack(
//         children: <Widget>[
//           SingleChildScrollView(
//             physics: ScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       ListTile(
//                         title: Text("Customer Name"),
//                         subtitle: name == null
//                             ? Text('name is not available')
//                             : Text(name),
//                         leading: Icon(
//                           Icons.person,
//                           color: Color(0xff44aae4),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _launched = _makePhoneCall('tel:$phone');
//                           });
//                         },
//                         child: ListTile(
//                           title: Text("Phone Number"),
//                           subtitle:
//                               phone == null
//                                   ? Text('phone is not available')
//                                   :
//                               Text(phone),
//                           leading: Icon(
//                             Icons.phone,
//                             color: Color(0xff44aae4),
//                           ),
//                           // Icon(
//                           //   onPressed: () {
//                           //     setState(() {
//                           //       _launched = _makePhoneCall('tel:+1 (425) 880-0977');
//                           //     });
//                           //   },
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             launch(_emailLaunchUri.toString());
//                           });
//                         },
//                         child: ListTile(
//                           title: Text("Email Id"),
//                           subtitle:
//                               email == null
//                                   ? Text('email is not available'):Text(email),
//                           leading: Icon(
//                             Icons.mail,
//                             color: Color(0xff44aae4),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           MapsLauncher.launchQuery(address);
//                         },
//                         child: ListTile(
//                           title: Text("Address"),
//                           subtitle:
//                               address == null?Text('address is not available'):Text(address),
//                           leading: Icon(
//                             Icons.my_location,
//                             color: Color(0xff44aae4),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           margin: EdgeInsets.only(top: 10, left: 5),
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             "Invoice",
//                             style: TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16),
//                             textAlign: TextAlign.left,
//                           ),
//                         ),
//                         Divider(
//                           color: Colors.black38,
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 6, right: 6),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5.0),
//                               border: Border.all(
//                                 color: Color(0xff44aae4),
//                               )),
//                           child: ListTile(
//                             leading: Text(
//                               'Show Invoice',
//                               style: TextStyle(
//                                   color: Color(0xff44aae4),
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             trailing: Icon(
//                               Icons.arrow_forward_ios,
//                               color: Color(0xff44aae4),
//                             ),
//                             selected: true,
//                             enabled: true,
//                             dense: true,
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Invoice(invoiceUrl: '',)),
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Align(
//           //   alignment: Alignment.bottomCenter,
//           //   child: val1
//           //       ? Container(
//           //           margin: EdgeInsets.only(left: 10, right: 30),
//           //           padding: EdgeInsets.only(
//           //               bottom: MediaQuery.of(context).viewInsets.bottom),
//           //           child: TextField(
//           //             // textInputAction: TextInputAction.send,
//           //             controller: _text,
//           //             keyboardType: TextInputType.multiline,
//           //             minLines: 2,
//           //             maxLines: 4,

//           //             decoration: InputDecoration(
//           //               errorText: _validate
//           //                   ? 'Please Fill Details then update the status'
//           //                   : null,
//           //               contentPadding: const EdgeInsets.symmetric(
//           //                 vertical: 10.0,
//           //                 horizontal: 20.0,
//           //               ),
//           //               border: OutlineInputBorder(
//           //                   borderRadius: BorderRadius.circular(10)),
//           //               hintText: 'Need details of incompletion',
//           //             ),
//           //           ),

//           //           // SizedBox(width: 10,),
//           //         )
//           //       : SizedBox(),
//           // ),
//           // Align(
//           //   alignment: Alignment.bottomCenter,
//           //   child: new Row(
//           //     mainAxisSize: MainAxisSize.max,
//           //     mainAxisAlignment: MainAxisAlignment.start,
//           //     children: <Widget>[
//           //       Expanded(
//           //         child: Container(
//           //             margin: EdgeInsets.all(5),
//           //             child: new RaisedButton(
//           //               child: new Text("Complete"),
//           //               textColor: Colors.white,
//           //               color: Color(0xff44aae4),
//           //               onPressed: () {
//           //                 setState(() {
//           //                   setEndPressed(2);
//           //                   // text = 'Complete';
//           //                   // val = true;
//           //                   showDialog(
//           //                     context: context,
//           //                     builder: (context) {
//           //                       return AlertDialog(
//           //                         shape: RoundedRectangleBorder(
//           //                             borderRadius:
//           //                                 BorderRadius.circular(12.0)),
//           //                         title: Text('Order Complete!'),
//           //                         content: Text(
//           //                             'Are you sure you want to Complete this order ?'),
//           //                         actions: <Widget>[
//           //                           FlatButton(
//           //                             onPressed: () {
//           //                               // Navigator.pop(context, false);
//           //                               Navigator.of(
//           //                                 context,
//           //                                 // rootNavigator: true,
//           //                               ).pop(false);
//           //                             },
//           //                             child: Text('No'),
//           //                           ),
//           //                           FlatButton(
//           //                             onPressed: () {
//           //                               // Navigator.pop(context, true);

//           //                               setState(() {
//           //                                 i = 2;
//           //                                 // changeStatus('completed');
//           //                                 Navigator.of(
//           //                                   context,
//           //                                   // rootNavigator: true,
//           //                                 ).pop(true);
//           //                               });
//           //                             },
//           //                             child: Text('Yes'),
//           //                           ),
//           //                         ],
//           //                       );
//           //                     },
//           //                   );
//           //                   val1 = false;

//           //                   _text.clear();
//           //                 });
//           //               },
//           //               shape: new RoundedRectangleBorder(
//           //                   borderRadius: new BorderRadius.circular(20.0)),
//           //             )),
//           //         flex: 1,
//           //       ),
//           //       Expanded(
//           //         child: Container(
//           //             margin: EdgeInsets.all(4),
//           //             child: new RaisedButton(
//           //               child: new Text("Incomplete"),
//           //               textColor: Colors.white,
//           //               color: Colors.red,
//           //               onPressed: () {
//           //                 // onTabChangeCallback();
//           //                 setState(() {
//           //                   _text.text.isEmpty
//           //                       ? _validate = true
//           //                       : _validate = false;
//           //                   val1 = true;

//           //                   setEndPressed(1);
//           //                 });
//           //                 _displayDialog(context);
//           //               },
//           //               shape: new RoundedRectangleBorder(
//           //                   borderRadius: new BorderRadius.circular(20.0)),
//           //             )),
//           //         flex: 1,
//           //       ),
//           //       Expanded(
//           //         child: Container(
//           //             margin: EdgeInsets.all(5),
//           //             child: new RaisedButton(
//           //               child: paid ? Text("Paid") : Text("Unpaid"),
//           //               textColor: Colors.white,
//           //               color: paid ? Colors.green : Colors.grey,
//           //               onPressed: () {
//           //                 // onTabChangeCallback();
//           //                 if (paid == true) {
//           //                   setState(() {
//           //                     paid = false;
//           //                   });
//           //                 } else {
//           //                   setState(() {
//           //                     // changeStatus('paid');
//           //                     paid = true;
//           //                   });
//           //                 }
//           //               },
//           //               shape: new RoundedRectangleBorder(
//           //                   borderRadius: new BorderRadius.circular(20.0)),
//           //             )),
//           //         flex: 1,
//           //       ),
//           //     ],
//           //   ),
//           // ),
//         ],
//       ),
//       bottomNavigationBar: new Container(
//         color: Colors.white.withOpacity(1),
//         padding: EdgeInsets.all(5),
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             Expanded(
//                 flex: 1,
//                 child: StepProgressIndicator(
//                   totalSteps: 3,
//                   currentStep: _currentValue,
//                   size: 25,
//                   selectedColor: Color(0xff44aae4),
//                   unselectedColor: Color(0xff69737f),
//                   customColor: (index) => index == 0
//                       ? Colors.yellow
//                       : index == 2
//                           ? paid ? Colors.green : Colors.grey[200]
//                           : _colors[i],
//                   customStep: (index, color, _) => index == 0
//                       ? Container(
//                           color: color,
//                           // child: Center(
//                           //     child: Row(
//                           //   crossAxisAlignment: CrossAxisAlignment.center,
//                           //   mainAxisAlignment: MainAxisAlignment.center,
//                           //   children: <Widget>[

//                           // Icon(
//                           //   Icons.check,
//                           //   color: Colors.white,
//                           // ),
//                           // Text(
//                           //   "Assigned",
//                           //   style: TextStyle(color: Colors.white),
//                           // ),
//                           //   ],
//                           // )),
//                         )
//                       : Container(
//                           color: color,

//                           // child: Center(
//                           //     child: Row(
//                           //   crossAxisAlignment: CrossAxisAlignment.center,
//                           //   mainAxisAlignment: MainAxisAlignment.center,
//                           //   children: <Widget>[
//                           //     val
//                           //         ? Icon(Icons.check, color: Colors.white)
//                           //         : Center(
//                           //             child: Icon(Icons.remove,
//                           //                 color: Colors.white)),
//                           //     val
//                           //         ? Text(
//                           //             text,
//                           //             style: TextStyle(color: Colors.white),
//                           //           )
//                           //         : SizedBox(),
//                           //   ],
//                           // )),
//                         ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   _displayDialog(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Notes'),
//             content: Container(
//               child: TextField(
//                 // textInputAction: TextInputAction.send,
//                 controller: _text,
//                 keyboardType: TextInputType.multiline,
//                 minLines: 3,
//                 maxLines: 4,

//                 decoration: InputDecoration(
//                   errorText:
//                       _validate ? 'Please Fill Details then Submit' : null,
//                   contentPadding: const EdgeInsets.symmetric(
//                     vertical: 10.0,
//                     horizontal: 20.0,
//                   ),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   hintText: 'Need details of incompletion',
//                 ),
//               ),

//               // SizedBox(width: 10,),
//             ),
//             actions: <Widget>[
//               new FlatButton(
//                 child: new Text('Cancel'),
//                 onPressed: () {
//                   setState(() {
//                     i = 0;
//                   });
//                   _text.clear();

//                   Navigator.of(context).pop();
//                 },
//               ),
//               new FlatButton(
//                 child: new Text('Submit'),
//                 onPressed: () {
//                   setState(() {
//                     if (_text.text.isNotEmpty) {
//                       _text.text.isEmpty ? _validate = true : _validate = false;
//                       i = 1;
//                       // addData();
//                       _currentValue = 1;
//                       val1 = true;
//                     } else {
//                       _text.text.isEmpty ? _validate = true : _validate = false;
//                       val1 = true;
//                       setEndPressed(1);
//                     }
//                   });
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           );
//         });
//   }

//   // changeStatus(String status) async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String token = prefs.getString("token");
//   //   String id = widget.id;

//   //   String url =
//   //       '$USER_DATA/restapi/user/change-installation-status/$id/$status';
//   //   http.post(
//   //     url,
//   //     headers: {
//   //       "content-type": "application/json",
//   //       "accept": "application/json",
//   //       HttpHeaders.authorizationHeader: 'Bearer $token'
//   //     },
//   //   ).then((response) {
//   //     if (response.statusCode == 500) {
//   //       Fluttertoast.showToast(
//   //           msg: "Status: $status",
//   //           toastLength: Toast.LENGTH_SHORT,
//   //           gravity: ToastGravity.BOTTOM,
//   //           timeInSecForIosWeb: 1,
//   //           backgroundColor: Colors.black,
//   //           textColor: Colors.white,
//   //           fontSize: 16.0);
//   //       print(response.statusCode);
//   //     } else {
//   //       print(response.statusCode);
//   //     }
//   //   });
//   // }

//   Future getData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString("token");
//     String id = widget.id;
// http.Response response = await http.get(
//        '${ApiBaseUrl.BASE_URL}/restapi/admin/project/$id',
//         headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
//     print(response.statusCode);
//     data = json.decode(response.body);
//     if(mounted){
// setState(() {
//       String fname = data['project']['firstname'];
//        name = '$fname';
//       phone = data['project']['phone'];
//       email = data['project']['email'];
//       address = data['project']['address'];
//       if (data['project']['installationstatus'] == 'completed') {
//         i = 2;
//       } else if (data['project']['installationstatus'] == 'incomplete') {
//         i = 1;
//       } else if (data['project']['installationstatus'] == 'paid') {
//         i = 2;
//         paid = true;
//       }
//     });
//     }

//   }

//   // addData() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String token = prefs.getString("token");
//   //   String id = widget.id;
//   //   String text = _text.text;
//   //   print('$text $id');

//   //   Map data = {
//   //     'id': widget.id,
//   //     'notes': _text.text,
//   //   };
//   //   String body = json.encode(data);
//   //   String url = '$USER_DATA/restapi/user/installation-data-save';
//   //   http
//   //       .post(
//   //     url,
//   //     headers: {
//   //       "content-type": "application/json",
//   //       "accept": "application/json",
//   //       HttpHeaders.authorizationHeader: 'Bearer $token'
//   //     },
//   //     body: body,
//   //   )
//   //       .then((response) {
//   //     if (response.statusCode == 500) {
//   //       print(response.statusCode);
//   //       changeStatus('incomplete');
//   //     } else {
//   //       print(response.statusCode);
//   //     }
//   //   });
//   // }

//   //  addData() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String token = prefs.getString("token");

//   //   var request = http.MultipartRequest(
//   //     "POST",
//   //     Uri.parse(
//   //       "${ApiBaseUrl.BASE_URL}/restapi/user/installation-data-save",
//   //     ),
//   //   );
//   //   request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
//   //   request.headers["Content-Type"] = 'multipart/form-data';
//   //   request.fields["id"] = widget.id;
//   //   request.fields["notes"] = _text.text;
//   //   request.send().then((onValue) {
//   //     if (onValue.statusCode == 200) {
//   //       changeStatus('incomplete');
//   //       setState(() {
//   //         i = 1;
//   //       });
//   //     } else {
//   //       print(onValue.statusCode);
//   //     }
//   //   });
//   // }
// }
// // _showImageDialog(String _img, String value) {
// //   showDialog(
// //     context: context,
// //     builder: (_) => Dialog(
// //       elevation: 0,
// //       backgroundColor: Colors.transparent,
// //       child: Column(
// //         children: <Widget>[
// //           Expanded(
// //             child: Container(
// //                 width: double.infinity,
// //                 child: PhotoView(
// //                   backgroundDecoration:
// //                       BoxDecoration(color: Colors.transparent),
// //                   imageProvider: AssetImage(_img),
// //                 )),
// //           ),
// //           Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
// //             IconButton(
// //               color: Colors.white,
// //               icon: Icon(Icons.close),
// //               onPressed: () => Navigator.pop(context),
// //             ),
// //             SizedBox(
// //               width: 10,
// //             ),
// //           ])
// //         ],
// //       ),
// //     ),
// //   );
// // }

// // typedef TabChangeCallback = void Function();
