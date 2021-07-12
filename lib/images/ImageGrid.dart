import 'dart:io';
import 'package:aq_admin/images/OrderImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class ImageGrid extends StatefulWidget {
  final List<File> imageList;
  final String name;
  ImageGrid({@required this.imageList, @required this.name});

  @override
  _ImageGridState createState() => _ImageGridState();
}
class _ImageGridState extends State<ImageGrid> {
  // List<String> _imageList = List();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;

  @override
  Widget build(BuildContext context) {
    Widget _buttons;
    if (_selectionMode) {
      _buttons = FloatingActionButton(
          child: Icon(Icons.delete),
          backgroundColor: Colors.red,
          onPressed: () {
            // print(
            //     'Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
            if (_selectedIndexList.length != null ||
                _selectedIndexList.length != 0) {
              for (int i in _selectedIndexList) {
                setState(() {
                  print(_selectedIndexList);
                  widget.imageList.removeAt(i);
                  _selectionMode = false;
                });
              }
            } else {
              Navigator.pop(context);
            }

            
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.black,
          actions: <Widget>[],
        ),
        backgroundColor: Colors.black,
        body: _createBody(),
        floatingActionButton: _buttons);
  }

  @override
  void initState() {
    super.initState();
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
      itemCount: widget.imageList.length,
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
              child: Image.file(
                widget.imageList[index],
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
          child: Image.file(
            widget.imageList[index],
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
                  builder: (context) => OrderImage(
                        imageList: widget.imageList,
                        index: index,
                      )),
            );
          },
        ),
      );
    }
  }
}
