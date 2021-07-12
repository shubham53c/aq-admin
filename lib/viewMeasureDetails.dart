import 'package:aq_admin/images/uploadedGrid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class ViewMeasure extends StatefulWidget {
  final String inspectiondate;
  final String measureTime;
  final String inspectionperson;
  final String projectStatus;
  final String inspectionstatus;
  final List allImageList;

  ViewMeasure({
    @required this.inspectiondate,
    @required this.measureTime,
    @required this.inspectionperson,
    @required this.inspectionstatus,
    @required this.projectStatus,
    @required this.allImageList,
  });
  @override
  _ViewMeasureState createState() => _ViewMeasureState();
}

class _ViewMeasureState extends State<ViewMeasure> {
  ProgressDialog pr;

  _getRequests() async {
    setState(() {});
  }

  var _selecteditem1;
  int _currentValue = 1;
  setEndPressed(int value) {
    setState(() {
      _currentValue = value;
    });
  }

  bool val = false;
  bool val1 = false;
  bool check = false;
  bool paid = false;
  bool showMeasure = false, showInstall = false;
  int i = 0;
  int statusno = 0;
  int installno = 0;
  bool _status = true;

  List<Color> _colors = [
    Colors.grey[200],
    Colors.red,
    Color(0xff44aae4),
  ];
  List<Color> _colors1 = [
    Colors.yellow[700],
    Colors.red,
    Colors.blue,
    Colors.grey
  ];
  List<Color> _colors3 = [
    Colors.yellow[700],
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.grey
  ];
  // List<Color> _colors = [Colors.grey[200], Colors.red, Color(0xff44aae4)];

  String text = 'incomplete';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // _name.text = widget.name;
    projectStatus();
  }

  projectStatus() {
    if (widget.inspectionstatus == 'completed') {
      i = 2;
    } else {
      i = 1;
    }
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
          backgroundColor: Color(0xff669cb2),
          radius: 17.0,
          child: _status
              ? Icon(
                  FontAwesomeIcons.userEdit,
                  color: Colors.white,
                  size: 17.0,
                )
              : Icon(
                  FontAwesomeIcons.edit,
                  color: Colors.white,
                  size: 17.0,
                )),
      onTap: () {
        if (_status == false) {
          setState(() {
            _status = true;
          });
        } else if (_status == true) {
          setState(() {
            _status = false;
          });
        }
      },
    );
  }

  bool onbackpress = false;
  onback() {
    Navigator.pop(context, onbackpress);
  }

  Future<bool> getPackageInfo() async {
    return onback();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Wait..',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return WillPopScope(
      onWillPop: () async => getPackageInfo(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xff649cb2),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Measure Details"),
          backgroundColor: Color(0xff669cb2),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, onbackpress)),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: Colors.white),
                    padding: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 70),
                                  child: Text(
                                    'Measurement Date & Time *',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    height: 50,
                                    width: 160,
                                    margin: EdgeInsets.only(left: 30),
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Color(0xff669cb2))),
                                    child: Row(
                                      children: <Widget>[
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.calendarAlt,
                                          size: 18,
                                          color: Color(0xff669cb2),
                                        )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Center(
                                            child: Text(
                                          widget.inspectiondate == null
                                              ? '---'
                                              : '${widget.inspectiondate}',
                                          style: TextStyle(fontSize: 16),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    height: 50,
                                    width: 115,
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Color(0xff669cb2))),
                                    child: Row(
                                      children: <Widget>[
                                        Center(
                                            child: Icon(
                                          FontAwesomeIcons.clock,
                                          size: 20,
                                          color: Color(0xff669cb2),
                                        )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Center(
                                            child: Text(
                                          widget.measureTime == null
                                              ? '---'
                                              : '${widget.measureTime}',
                                          style: TextStyle(fontSize: 16),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 70),
                                child: Text(
                                  'Measurement Assigned To *',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Container(
                                    width: 500,
                                    margin: EdgeInsets.only(right: 55),
                                    padding: const EdgeInsets.only(
                                        left: 35.0, right: 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(color: _colors[i])),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: widget.inspectionperson == null
                                          ? Text('---')
                                          : Text(
                                              toBeginningOfSentenceCase(
                                                  widget.inspectionperson),
                                              style: TextStyle(fontSize: 16)),
                                    ))),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 110),
                                child: Text(
                                  'Measurement Status *',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Container(
                                    width: 500,
                                    margin: EdgeInsets.only(right: 55),
                                    padding: const EdgeInsets.only(
                                        left: 35.0, right: 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(color: _colors[i])),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: widget.inspectionstatus == null
                                          ? Text('---')
                                          : Text(
                                              toBeginningOfSentenceCase(
                                                  widget.inspectionstatus),
                                              style: TextStyle(fontSize: 16)),
                                    ))),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 160),
                          child: Text(
                            'Project Status *',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                              width: 500,
                              margin: EdgeInsets.only(right: 55),
                              padding: const EdgeInsets.only(
                                  left: 35.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: widget.projectStatus == null
                                    ? Text('---')
                                    : Text(
                                        toBeginningOfSentenceCase(
                                            widget.projectStatus),
                                        style: TextStyle(fontSize: 16)),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 50),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: 4,
                            decoration: InputDecoration(
                                labelText: 'Measurements Notes',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Measurements Notes'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 180,
                          child: VerticalTabs(
                              selectedTabBackgroundColor: Color(0xff669cb2),
                              backgroundColor: Colors.grey[100],
                              contentScrollAxis: Axis.horizontal,
                              //indicatorColor: Colors.black,
                              indicatorSide: IndicatorSide.end,
                              tabsElevation: 5,
                              tabsWidth: 76,
                              tabs: [
                                Tab(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'All Images',
                                    ),
                                  ),
                                ),
                              ],
                              contents: [
                                Container(
                                  child: widget.allImageList == null ||
                                          widget.allImageList.length == 0
                                      ? Center(
                                          child:
                                              Text('Images is not available'),
                                        )
                                      : Swiper(
                                          itemCount: widget.allImageList.length,
                                          layout: SwiperLayout.STACK,
                                          itemWidth: 180,
                                          autoplay: false,
                                          scrollDirection: Axis.horizontal,
                                          onTap: (index) {
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                builder: (_) => UploadedGrid(
                                                  imageList:
                                                      widget.allImageList,
                                                  name: 'All Images',
                                                ),
                                              ),
                                            );
                                          },
                                          itemBuilder: (context, index) =>
                                              Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              child: widget.allImageList[index]
                                                          ['imageUrl'] ==
                                                      null
                                                  ? Center(
                                                      child: Text("No Image"))
                                                  : CachedNetworkImage(
                                                      imageUrl: widget
                                                              .allImageList[
                                                          index]['imageUrl'],
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child: SizedBox(
                                                          child:
                                                              CircularProgressIndicator(),
                                                          height: 20.0,
                                                          width: 20.0,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                              // Image.network(
                                              //     widget.allImageList[index]
                                              //         ['imageUrl'])
                                            ),
                                          ),
                                        ),
                                ),
                              ]),
                        ),
                      ],
                    )),
              ),
            ],
          ),
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
                      size: 10,
                      selectedColor: Color(0xff44aae4),
                      unselectedColor: Color(0xff69737f),
                      customColor: (index) => index == 0
                          ? Colors.yellow[700]
                          : index == 2
                              ? paid
                                  ? Colors.green
                                  : Colors.grey[200]
                              : _colors[i],
                      customStep: (index, color, _) => index == 0
                          ? Container(
                              color: color,
                            )
                          : Container(
                              color: color,
                            ))),
            ],
          ),
        ),
      ),
    );
  }
}
