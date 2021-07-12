import 'dart:io';
import 'dart:typed_data';
import 'package:aq_admin/images/OrderImage.dart';
import 'package:aq_admin/uploadedImages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UploadedGrid extends StatefulWidget {
  final List imageList;
  final String name;
  UploadedGrid({@required this.imageList, @required this.name});
  @override
  _UploadedGridState createState() => _UploadedGridState();
}

class _UploadedGridState extends State<UploadedGrid> {
  // List<String> _imageList = List();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;
  List<String> fileShare = [];
  Map<String, List<int>> bytesData = {};

  @override
  Widget build(BuildContext context) {
    Widget _buttons;
    if (_selectionMode) {
      _buttons = FloatingActionButton(
          child: Icon(Icons.share),
          backgroundColor: Colors.blue,
          onPressed: () async {
            // print(
            //     'Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
            if (_selectedIndexList.length != null ||
                _selectedIndexList.length != 0) {
              _shareImageFromUrl();
              //  try {
              //   var request = await HttpClient()
              //       .getUrl(Uri.parse(widget.imageList[_selectedIndexList[0]]['imageUrl']));
              //   var response = await request.close();
              //   Uint8List bytes =
              //       await consolidateHttpClientResponseBytes(response);
              //   await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
              // } catch (e) {
              //   print('error: $e');
              // }

            } else {
              Navigator.pop(context);
            }

            // for (var i in _selectedIndexList) {
            // do {
            //   print(i);
            //   setState(() {
            //     _imageList.removeAt(i);
            //   });
            // } while (i < 0);
            // _selectionMode = false;

            // if (_selectedIndexList.length == 3) {
            //   setState(() {
            //     widget.imageList.clear();
            //     _selectionMode = false;
            //   });
            // } else if (i == 0) {
            //   setState(() {
            //     widget.imageList.removeAt(i);
            //   });
            // } else if (_selectedIndexList.length == 0) {
            //   _selectionMode = false;
            // }

            // print(i);
            // if(widget.imageList!=null){
            //   setState(() {
            //     widget.imageList.
            //   });
            // }
            // }
          });
    }

    return WillPopScope(
      onWillPop: () async => getPackageInfo(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.name),
            backgroundColor: Colors.black,
            actions: <Widget>[],
          ),
          backgroundColor: Colors.black,
          body: _createBody(),
          floatingActionButton: _buttons),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  bool onbackpress = false;
  onback() {
    if (onbackpress == true) {
      Navigator.pop(context, onbackpress);
      // if (projectstatus == 'needs estimate' ||
      //     projectstatus == 'waiting approval' ||
      //     projectstatus == 'needs ordering' ||
      //     projectstatus == 'waiting delivery') {
      //   showEstimateDialog();
      // } else {
      //   Navigator.pop(context, onbackpress);
      // }
    } else {
      Navigator.pop(context, onbackpress);
    }
  }

  Future<bool> getPackageInfo() async {
    return onback();
  }

  void _changeSelection({bool enable, int index}) {
    if (index == -1) {
      _selectionMode = enable;
      _selectedIndexList.clear();
      fileShare.clear();
      print(_selectedIndexList);
    } else {
      setState(() {
        _selectionMode = enable;
        _selectedIndexList.add(index);
        fileShare.add(widget.imageList[index]['imageUrl']);
      });

      print(_selectedIndexList);
    }
  }

  void _shareImageFromUrl() async {
    for (int i = 0; i < fileShare.length; i++) {
      var request = await HttpClient().getUrl(Uri.parse(fileShare[i]));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      bytesData.addAll({'AQ Glass$i.jpg': bytes.buffer.asUint8List()});
    }
    await Share.files('AQ Glass', bytesData, 'image/png');
  }

  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      primary: false,
      itemCount: widget.imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: const EdgeInsets.all(4.0),
    );
  }

  GridTile getGridTile(int index) {
    print("getGridTileCalled");
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
              child: widget.imageList[index]['imageUrl'] == null
                  ? Center(child: Text("No Image"))
                  : CachedNetworkImage(
                      imageUrl: widget.imageList[index]['imageUrl'],
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          height: 20.0,
                          width: 20.0,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
              // child: Image.network(
              //   widget.imageList[index]['imageUrl'],
              //   fit: BoxFit.cover,
              // ),
            ),
            onLongPress: () {
              setState(() {
                _changeSelection(enable: false, index: -1);
              });
            },
            onTap: () {
              setState(() {
                try {
                  if (_selectedIndexList.contains(index)) {
                    _selectedIndexList.remove(index);
                    fileShare.removeAt(index);
                    print(fileShare);
                  } else {
                    _selectedIndexList.add(index);
                    fileShare.add(widget.imageList[index]['imageUrl']);
                    print(fileShare);
                  }
                } catch (e) {
                  print(e);
                  _changeSelection(enable: false, index: -1);
                }
              });
            },
          ));
    } else {
      return GridTile(
        child: InkResponse(
          child: widget.imageList[index]['imageUrl'] == null
              ? Center(child: Text("No Image"))
              : CachedNetworkImage(
                  imageUrl: widget.imageList[index]['imageUrl'],
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      height: 20.0,
                      width: 20.0,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
          },
          onTap: () async {
            goToSecondScreen(index);
          },
        ),
      );
    }
  }

  void goToSecondScreen(int index) async {
    var result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => UploadedImages(
                  imageList: widget.imageList,
                  index: index,
                  name: widget.name,
                )));
    print(result);
    if (result != null) {
      setState(() {
        var i = int.parse(result);
        widget.imageList.remove(i);
        onbackpress = true;
      });

// }

    }
  }
}
