import 'dart:convert';
import 'dart:io';
import 'package:aq_admin/Image_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'base_url.dart';

class OrderDetails extends StatefulWidget {
  final String id;
  OrderDetails({@required this.id});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int _currentValue = 1;
  setEndPressed(int value) {
    setState(() {
      _currentValue = value;
    });
  }

  // List<String> _imageList = List();

  List<int> _selectedIndexList = List();
  bool _selectionMode = false;

  int i = 0;
  List<Color> _colors = [Colors.grey[200], Colors.red, Color(0xff44aae4)];
  bool val1 = false;
  bool val = false;
  bool paid = false;
  final _text = TextEditingController();
  bool _validate = false;
  Map data;
  String measurementNotes;

  @override
  Widget build(BuildContext context) {
    Widget _buttons;
    if (_selectionMode) {
      _buttons = FloatingActionButton(
          child: Icon(Icons.share),
          backgroundColor: Colors.blue,
          onPressed: () async {
            // try {
            //   var request = await HttpClient()
            //       .getUrl(Uri.parse(images[_selectedIndexList[0]]));
            //   var response = await request.close();
            //   Uint8List bytes =
            //       await consolidateHttpClientResponseBytes(response);
            //   await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
            // } catch (e) {
            //   print('error: $e');
            // }

            print(
                'Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
            // for (var i in _selectedIndexList) {
            //   // do {
            //   //   print(i);
            //   //   setState(() {
            //   //     _imageList.removeAt(i);
            //   //   });
            //   // } while (i < 0);
            //   // _selectionMode = false;

            //   if (_selectedIndexList.length == 3) {
            //     setState(() {
            //       _imageList.clear();
            //       _selectionMode = false;
            //     });
            //   } else if (i == 0) {
            //     setState(() {
            //       _imageList.removeAt(i);
            //     });
            //   } else if (_selectedIndexList.length == 0) {
            //     _selectionMode = false;
            //   }

            //   print(i);
            // }
          });
    }
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      floatingActionButton: _buttons,
      body: data == null || data.length == 0
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Measuring Notes",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: measurementNotes == null ||
                                        measurementNotes == ''
                                    ? Text(
                                        'Measurement notes is not available.')
                                    : Text(measurementNotes),
                                leading: Icon(
                                  Icons.event_note,
                                  size: 30,
                                  color: Color(0xff44aae4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Layout and Orders images',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      images == null || images.length == 0
                          ? Text('Not available')
                          : _createBody()

                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(5.0),
                      //     ),
                      //     child: Column(
                      //       children: <Widget>[
                      //         Container(
                      //           margin: EdgeInsets.only(top: 10, left: 5),
                      //           alignment: Alignment.topLeft,
                      //           child: Text(
                      //             "Invoice",
                      //             style: TextStyle(
                      //                 color: Colors.black87,
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize: 16),
                      //             textAlign: TextAlign.left,
                      //           ),
                      //         ),
                      //         Divider(
                      //           color: Colors.black38,
                      //         ),
                      //         Container(
                      //           margin: EdgeInsets.only(left: 6, right: 6),
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(5.0),
                      //               border: Border.all(
                      //                 color: Color(0xff44aae4),
                      //               )),
                      //           child: ListTile(
                      //             leading: Text(
                      //               'Show Invoice',
                      //               style: TextStyle(
                      //                   color: Color(0xff44aae4),
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //             trailing: Icon(
                      //               Icons.arrow_forward_ios,
                      //               color: Color(0xff44aae4),
                      //             ),
                      //             selected: true,
                      //             enabled: true,
                      //             dense: true,
                      //             onTap: () {
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => Invoice()),
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: 10,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: new Row(
                //     mainAxisSize: MainAxisSize.max,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       Expanded(
                //         child: Container(
                //             margin: EdgeInsets.all(5),
                //             child: new RaisedButton(
                //               child: new Text("Complete"),
                //               textColor: Colors.white,
                //               color: Color(0xff44aae4),
                //               onPressed: () {
                //                 setState(() {
                //                   setEndPressed(2);
                //                   // text = 'Complete';
                //                   // val = true;
                //                   val1 = false;
                //                   i = 2;
                //                   _text.clear();
                //                 });
                //               },
                //               shape: new RoundedRectangleBorder(
                //                   borderRadius: new BorderRadius.circular(20.0)),
                //             )),
                //         flex: 1,
                //       ),
                //       Expanded(
                //         child: Container(
                //             margin: EdgeInsets.all(4),
                //             child: new RaisedButton(
                //               child: new Text("Incomplete"),
                //               textColor: Colors.white,
                //               color: Colors.red,
                //               onPressed: () {
                //                 // onTabChangeCallback();
                //                 setState(() {
                //                   _text.text.isEmpty
                //                       ? _validate = true
                //                       : _validate = false;
                //                   val1 = true;

                //                   setEndPressed(1);
                //                 });
                //                 _displayDialog(context);
                //               },
                //               shape: new RoundedRectangleBorder(
                //                   borderRadius: new BorderRadius.circular(20.0)),
                //             )),
                //         flex: 1,
                //       ),
                //       Expanded(
                //         child: Container(
                //             margin: EdgeInsets.all(5),
                //             child: new RaisedButton(
                //               child: paid ? Text("Paid") : Text("Unpaid"),
                //               textColor: Colors.white,
                //               color: paid ? Colors.green : Colors.grey,
                //               onPressed: () {
                //                 // onTabChangeCallback();
                //                 if (paid == true) {
                //                   setState(() {
                //                     paid = false;
                //                   });
                //                 } else {
                //                   setState(() {
                //                     paid = true;
                //                   });
                //                 }
                //               },
                //               shape: new RoundedRectangleBorder(
                //                   borderRadius: new BorderRadius.circular(20.0)),
                //             )),
                //         flex: 1,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
      bottomNavigationBar: new Container(
        color: Colors.white.withOpacity(1),
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: StepProgressIndicator(
                  totalSteps: 3,
                  currentStep: _currentValue,
                  size: 25,
                  selectedColor: Color(0xff44aae4),
                  unselectedColor: Color(0xff69737f),
                  customColor: (index) => index == 0
                      ? Colors.yellow
                      : index == 2
                          ? paid
                              ? Colors.green
                              : Colors.grey[200]
                          : _colors[i],
                  customStep: (index, color, _) => index == 0
                      ? Container(
                          color: color,
                          // child: Center(
                          //     child: Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[

                          // Icon(
                          //   Icons.check,
                          //   color: Colors.white,
                          // ),
                          // Text(
                          //   "Assigned",
                          //   style: TextStyle(color: Colors.white),
                          // ),
                          //   ],
                          // )),
                        )
                      : Container(
                          color: color,

                          // child: Center(
                          //     child: Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          //     val
                          //         ? Icon(Icons.check, color: Colors.white)
                          //         : Center(
                          //             child: Icon(Icons.remove,
                          //                 color: Colors.white)),
                          //     val
                          //         ? Text(
                          //             text,
                          //             style: TextStyle(color: Colors.white),
                          //           )
                          //         : SizedBox(),
                          //   ],
                          // )),
                        ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print(widget.id);
    getData();
    // _imageList.add('lib/assets/img1.jpeg');
    // _imageList.add('lib/assets/img2.jpeg');
    // _imageList.add('lib/assets/glass1.jpg');
  }

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: const EdgeInsets.all(4.0),
    );
  }

  GridTile getGridTile(int index) {
    if (_selectionMode) {
      return GridTile(
          header: GridTileBar(
            leading: Icon(
              _selectedIndexList.contains(index)
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index)
                  ? Colors.green
                  : Colors.black,
            ),
          ),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[50], width: 30.0)),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
            onLongPress: () {
              setState(() {
                _changeSelection(enable: false, index: -1);
              });
            },
            onTap: () {
              setState(() {
                if (_selectedIndexList.contains(index)) {
                  _selectedIndexList.remove(index);
                } else {
                  _selectedIndexList.add(index);
                }
              });
            },
          ));
    } else {
      return GridTile(
        child: InkResponse(
          child: Image.network(
            images[index],
            fit: BoxFit.cover,
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageView(
                        index: index,
                        imagelist: images,
                      )),
            );
          },
        ),
      );
    }
  }

  List layoutimageList;
  List ordersimageList;
  List<String> images = [];
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String id = widget.id;
    http.Response response = await http.get(
        '${ApiBaseUrl.BASE_URL}/restapi/admin/project/$id',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(response.statusCode);
    data = json.decode(response.body);
    print(data);
    setState(() {
      measurementNotes = data['project']['notes'];
      layoutimageList = data['project']['layoutslist'];
      ordersimageList = data['project']['orderslist'];
      if (data['project']['installationstatus'] == 'completed') {
        i = 2;
      } else if (data['project']['installationstatus'] == 'incomplete') {
        i = 1;
      } else if (data['project']['installationstatus'] == 'paid') {
        i = 2;
        paid = true;
      }

      if (layoutimageList != null || layoutimageList.length != 0) {
        for (var i in layoutimageList) {
          images.add(i['imageUrl']);
          print(images);
        }
      }
      if (ordersimageList != null || ordersimageList.length != 0) {
        for (var i in ordersimageList) {
          images.add(i['imageUrl']);
          print(images);
        }
      }
    });
  }

  // Future<void> _shareImageFromUrl(String url) async {
  //   try {
  //     var request = await HttpClient().getUrl(Uri.parse(url));
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
  //   } catch (e) {
  //     print('error: $e');
  //   }
  // }

}
