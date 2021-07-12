import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';

class OrderImage extends StatefulWidget {
  final List<File> imageList;
  final int index;
  OrderImage({@required this.imageList, @required this.index});

  @override
  _OrderImageState createState() => _OrderImageState();
}

class _OrderImageState extends State<OrderImage> {
  exit() {
    Navigator.pop(context, true);
  }

  Future<bool> _onBackPressed() {
    return exit();
  }

  @override
  Widget build(BuildContext context) {
    int i;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: widget.imageList.length == 0 || widget.imageList == null
              ? Center(
                  child: Text(
                    "No Images Uploaded yet",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          print(index);
                        },
                        child: Container(
                            child: PhotoView(
                          imageProvider: FileImage(widget.imageList[index]),
                        )),
                      );
                    },
                    autoplay: false,
                    loop: false,
                    itemCount: widget.imageList.length,
                    pagination: new SwiperPagination(
                        margin: new EdgeInsets.all(0.0),
                        builder: new SwiperCustomPagination(builder:
                            (BuildContext context, SwiperPluginConfig config) {
                          i = config.activeIndex;
                          return ConstrainedBox(
                            child: new Container(
                                color: Colors.white,
                                child: new Text(
                                  "  Images ${config.activeIndex + 1}/${config.itemCount}",
                                  style: new TextStyle(fontSize: 20.0),
                                )),
                            constraints:
                                new BoxConstraints.expand(height: 30.0),
                          );
                        })),
                    // control: new SwiperControl(),
                  ),
                )),
    );
  }
}
