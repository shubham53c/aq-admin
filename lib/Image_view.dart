import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {
  final List imagelist;
  final int index;
  ImageView({@required this.index, @required this.imagelist});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Swiper(
          itemWidth: 330.0,
          itemHeight: 300.0,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                print(index);
              },
              child: Container(
                  height: 300,
                  width: 300,
                  child: PhotoView(
                    imageProvider:
                        NetworkImage(widget.imagelist[index]),
                  )),
            );
          },
          autoplay: false,
          loop: false,
          index: widget.index,
          scrollDirection: Axis.horizontal,  
          itemCount: widget.imagelist.length, 
          pagination: new SwiperPagination(
              margin: new EdgeInsets.all(0.0),
              builder: new SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                return ConstrainedBox(
                  child: new Container(
                      color: Colors.white,
                      child: new Text(
                        "  Images ${config.activeIndex + 1}/${config.itemCount}",
                        style: new TextStyle(fontSize: 20.0),
                      )),
                  constraints: new BoxConstraints.expand(height: 30.0),
                );
              })),
          // control: new SwiperControl(),
        ),
      ),
    );
  }
}
