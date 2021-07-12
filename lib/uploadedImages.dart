import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'base_url.dart';

class UploadedImages extends StatefulWidget {
  final List imageList;
  final String name;
  final int index;

  UploadedImages(
      {@required this.imageList, @required this.name, @required this.index});

  @override
  _UploadedImagesState createState() => _UploadedImagesState();
}

class _UploadedImagesState extends State<UploadedImages> {
  bool detectChanges = false;
// bool onbackpress=false;
// onback() {
//     if (onbackpress==true) {
//      Navigator.pop(context, onbackpress);
//       // if (projectstatus == 'needs estimate' ||
//       //     projectstatus == 'waiting approval' ||
//       //     projectstatus == 'needs ordering' ||
//       //     projectstatus == 'waiting delivery') {
//       //   showEstimateDialog();
//       // } else {
//       //   Navigator.pop(context, onbackpress);
//       // }
//     } else {
//       Navigator.pop(context, onbackpress);
//     }
//   }

//   Future<bool> getPackageInfo() async {
//     return onback();
//   }
  bool val = true;
  bool indicator = false;
  @override
  void initState() {
    super.initState();
    print(widget.name);
    showdelete();
  }

  showdelete() {
    if (widget.name == 'All Images') {
      val = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    int i;
    return Scaffold(
        backgroundColor: Colors.black,
        body: widget.imageList.length == 0 || widget.imageList == null
            ? Center(
                child: Text(
                  "No Images Uploaded yet",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Stack(children: <Widget>[
                Center(
                    child:
                        indicator ? CircularProgressIndicator() : SizedBox()),
                Container(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          print(index);
                        },
                        child: Container(
                            child: PhotoView(
                          imageProvider:
                              NetworkImage(widget.imageList[index]['imageUrl']),
                        )),
                      );
                    },
                    autoplay: false,
                    loop: false,
                    itemCount: widget.imageList.length,
                    index: widget.index,
                    pagination: new SwiperPagination(
                        margin: new EdgeInsets.all(0.0),
                        builder: new SwiperCustomPagination(builder:
                            (BuildContext context, SwiperPluginConfig config) {
                          return ConstrainedBox(
                            child: new Container(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    new Text(
                                      "Images ${config.activeIndex + 1}/${config.itemCount}",
                                      style: new TextStyle(fontSize: 20.0),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 200),
                                        child: val
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 24,
                                                ),
                                                onPressed: () {
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
                                                            'Delete Image !'),
                                                        content: Text(
                                                            'Are you sure you want to Delete this Image ?'),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            onPressed: () {
                                                              // Navigator.pop(context, false);
                                                              Navigator.of(
                                                                context,
                                                                // rootNavigator: true,
                                                              ).pop(false);
                                                            },
                                                            child: Text('No'),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () {
                                                              // Navigator.pop(context, true);
                                                              setState(() {
                                                                indicator =
                                                                    true;
                                                                deleteProject(
                                                                    widget.imageList[
                                                                            config.activeIndex]
                                                                        [
                                                                        'linkedId'],
                                                                    widget.imageList[
                                                                            config.activeIndex]
                                                                        ['id'],
                                                                    config
                                                                        .activeIndex
                                                                        .toString());
                                                                widget.imageList
                                                                    .removeAt(config
                                                                        .activeIndex);
                                                                print(config
                                                                    .activeIndex);

                                                                Navigator.of(
                                                                  context,
                                                                  // rootNavigator: true,
                                                                ).pop(true);
                                                              });
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                })
                                            : SizedBox()),
                                  ],
                                )),
                            constraints:
                                new BoxConstraints.expand(height: 30.0),
                          );
                        })),
                    // control: new SwiperControl(),
                  ),
                ),
              ]));
  }

  deleteProject(String linkedId, id, index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String name = widget.name;
    String url =
        '${ApiBaseUrl.BASE_URL}/restapi/admin/deleteprojectimage/$name/$linkedId/$id';
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
        print('Suceess');

        setState(() {
          // print(response.statusCode);
          Navigator.pop(context, index);

          //  print(userData[i]['name']);
        });
      } else {
        print(response.statusCode);
      }
    });
  }
}
