import 'dart:convert';
import 'dart:io';
import 'package:aq_admin/stful_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:aq_admin/CapitalText.dart';
import 'package:aq_admin/Install.dart';
import 'package:aq_admin/Invoice.dart';
import 'package:aq_admin/images/ImageGrid.dart';
import 'package:aq_admin/images/uploadedGrid.dart';
import 'package:aq_admin/viewMeasureDetails.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

import 'base_url.dart';

class Measurements extends StatefulWidget {
  final String id;
  final List employee;
  final List installer;
  final List projectStatus;
  final String name;
  String tabName;
  Measurements(
      {@required this.id,
      @required this.employee,
      @required this.name,
      @required this.installer,
      @required this.projectStatus,
      @required this.tabName});
  @override
  _MeasurementsState createState() => _MeasurementsState();
}

class _MeasurementsState extends State<Measurements> {
  ProgressDialog pr;

  _getRequests() async {
    setState(() {
      images.length;
    });
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

  TextEditingController _name = TextEditingController();
  TextEditingController _pname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _mobno = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _notes = TextEditingController();
  final _text = TextEditingController();
  bool _validate = false;

  var myData;
  File _image, _image1;
  final picker = ImagePicker();
  final picker1 = ImagePicker();
  String itemid;
  String measureTime, installTime;
  List<String> userList;
  List<File> images = [];
  List<File> images1 = [];
  bool _loadingPath = false;
  var _path;
  Map<String, String> _paths;
  File file, invoice;
  List<File> file1 = [];
  String _extension;
  DateTime pickedDate;
  bool isload = false;
  TimeOfDay time;
  var selectedDateTime;
  DateFormat finalDate = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateFormat timeformat = DateFormat('hh:mm');
  String previousName;
  String previousMob;
  String previousEmail;
  String previousAddress;
  String previousNotes;

  String invoiceName;
  _openInvoice() async {
    setState(() => _loadingPath = true);
    try {
      // _path = null;
      _paths = await FilePicker.getMultiFilePath(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      if (_paths != null) {
        for (var i in _paths.entries) {
          invoice = new File(i.value);
          // images1.add(file);
          print(invoice);
          invoiceName = invoice.path.split('/').last;
          //  print(fileName);
          //  showInvoiceDialog(fileName);
          // detectChanges=true;
        }
        showInvoiceDialog(invoiceName);
        // Navigator.pop(context);
      }
    });
  }

  List<File> newLayoutImages = [];
  List<File> newOrderImages = [];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      images.add(_image);
      newLayoutImages.add(_image);
      detectChanges = true;
      Navigator.pop(context);
      // _displaySnackBar(context, 'Images added for Layout', images);
    });
  }

  Future getImage1() async {
    final pickedFile1 = await picker1.getImage(source: ImageSource.camera);
    print(pickedFile1);

    setState(() {
      _image1 = File(pickedFile1.path);
      images1.add(_image1);
      newOrderImages.add(_image);
      Navigator.pop(context);
      // _displaySnackBar1(context, 'Images added for Orders', images1);
    });
  }

  _openFileExplorer1() async {
    setState(() => _loadingPath = true);
    try {
      // _path = null;
      _paths = await FilePicker.getMultiFilePath(
          type: FileType.image,
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll('', '')?.split(',')
              : null);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      if (_paths != null) {
        for (var i in _paths.entries) {
          file = new File(i.value);
          images1.add(file);
          newOrderImages.add(file);
          print(images);
          detectChanges = true;
        }
        Navigator.pop(context);
      }
    });
  }

  _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      // _path = null;
      _paths = await FilePicker.getMultiFilePath(
          type: FileType.image,
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll('', '')?.split(',')
              : null);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      if (_paths != null) {
        for (var i in _paths.entries) {
          file = new File(i.value);
          images.add(file);
          newLayoutImages.add(file);
          print(images);
          detectChanges = true;
        }
        Navigator.pop(context);
        // setState(() {
        //   if (file1 != null && file1.isNotEmpty) {
        //     _navigatetoMediaPage(context);
        //   } else {
        //     print('cancel');
        //   }
        // });
        // print(file1);
        //  sendMessage();
      }
    });
  }

  // _displaySnackBar(BuildContext context, String msg, List image) {
  //   int i = image.length;
  //   final snackBar = SnackBar(
  //     content: Text('$msg : $i'),
  //     action: SnackBarAction(
  //       label: 'View Image',
  //       onPressed: () {
  //         setState(() {
  //           Navigator.of(context)
  //               .push(
  //                 new MaterialPageRoute(
  //                   builder: (_) => ImageGrid(
  //                     imageList: images,
  //                     name: 'Layout Images',
  //                   ),
  //                 ),
  //               )
  //               .then((val) => val ? _getRequests() : null);
  //           // userlist.removeAt(i);
  //         });
  //       },
  //     ),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackBar);
  // }

  // _displaySnackBar1(BuildContext context, String msg, List image) {
  //   int i = image.length;
  //   final snackBar = SnackBar(
  //     content: Text('$msg : $i'),
  //     action: SnackBarAction(
  //       label: 'View Image',
  //       onPressed: () {
  //         setState(() {
  //           print(images);
  //           Navigator.of(context)
  //               .push(
  //                 new MaterialPageRoute(
  //                   builder: (_) => ImageGrid(
  //                     imageList: images1,
  //                     name: 'Order Images',
  //                   ),
  //                 ),
  //               )
  //               .then((val) => val ? _getRequests() : null);
  //           // userlist.removeAt(i);
  //         });
  //       },
  //     ),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackBar);
  // }

  List measureemp, installemp;
  List estimateStatus = ['needs estimate', 'waiting approval'];
  List orderStatus = ['needs ordering', 'waiting delivery'];
  List priority = ['high', 'medium', 'low'];
  // List status = [
  //   'select status',
  //   'completed',
  //   'assigned',
  //   'incomplete',
  //   'paid'
  // ];
  // List measureStatus = [
  //   'select status',
  //   'completed',
  //   'assigned',
  //   'incomplete',
  // ];
  // List projectStatus=[];

  @override
  void initState() {
    super.initState();
    // _name.text = widget.name;
    print('projectStatus: ${widget.projectStatus}');
    print(widget.employee);
    measureemp = widget.employee;
    installemp = widget.installer;
    Future.delayed(Duration.zero).then((_) async {
      await getData();
      currentProjectStatus = projectstatus;
      print('Current project Status: $currentProjectStatus');
      cureentDateTime();
      showWidget();
      if (currentProjectStatus == 'needs ordering') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('lastNeedOrderingProjectName', '${_name.text}');
      }
    });
  }

  ScrollController _scrollController = new ScrollController();
  goUp() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
      );
    });
    print('Scroll');
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
            detectChanges = true;
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
  bool detectChanges = false;
  bool changesMadeToTextFields = false;
  bool projectStatusUpdated = false;

  String detetectedCircumstance = 'No change made';

  checkCircumstances({bool clickedSubmit = false}) {
    print(
        'changesMadeToTextFields: $changesMadeToTextFields\nprojectStatusUpdated: $projectStatusUpdated\ndetectChanges: $detectChanges');
    if (changesMadeToTextFields == false &&
        projectStatusUpdated &&
        detectChanges == false &&
        currentProjectStatus != projectstatus) {
      detetectedCircumstance = 'Only project status updated';
      if (clickedSubmit) {
        showUnsavedDialog(clickedSubmit: true);
      } else {
        showUnsavedDialog();
      }
    } else if ((changesMadeToTextFields || detectChanges) &&
        projectStatusUpdated == false) {
      detetectedCircumstance = 'Other changes without status change';
      if (clickedSubmit) {
        showUnsavedDialog1(clickedSubmit: true);
      } else {
        showUnsavedDialog1();
      }
    } else if (((changesMadeToTextFields || detectChanges) &&
            projectStatusUpdated) &&
        currentProjectStatus != projectstatus) {
      detetectedCircumstance = 'Other changes with status change';
      if (clickedSubmit) {
        showUnsavedDialog(clickedSubmit: true);
      } else {
        showUnsavedDialog();
      }
    } else {
      if (clickedSubmit) {
        Fluttertoast.showToast(
          msg: 'No Change Made',
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      } else {
        if (currentProjectStatus == 'needs ordering') {
          noChangeConfirmation();
        } else {
          Navigator.of(context).pop(true);
        }
      }
    }
  }

  noChangeConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Center(
          child: Text(
            'Order is still in\nNEEDS ORDERING\nstatus?',
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(ctx).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('lastNeedOrderingProjectName');
                  },
                ),
                TextButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  preInitializationForCircumstanceDetection() {
    if (previousName != _name.text ||
        previousMob != _mobno.text ||
        previousEmail != _email.text ||
        previousAddress != _address.text ||
        previousNotes != _notes.text) changesMadeToTextFields = true;
    if (currentProjectStatus != projectstatus) projectStatusUpdated = true;
  }

  onback() {
    preInitializationForCircumstanceDetection();
    //widget.tab=='orders'
    if (
        // (changesMadeToTextFields || projectStatusUpdated || detectChanges) &&
        widget.tabName != 'Current Project') {
      checkCircumstances();
      // showUnsavedDialog();
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
    if (data == null || data.length == 0) {
      return Future.value(false);
    } else {
      return onback();
    }
  }

  bool fromDailog = false;
  showInvoiceDialog(String fileName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text('Are you sure !'),
          content: Text('Selected file $fileName.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                // Navigator.pop(context, false);
                Navigator.of(
                  context,
                  // rootNavigator: true,
                ).pop(true);
                //  Navigator.pop(context, onbackpress);
              },
              child: Text('Cancel',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ),
            FlatButton(
              onPressed: () {
                // Navigator.pop(context, true);
                setState(() {
                  fromDailog = true;
                  sendInvoice();
                  Navigator.of(
                    context,
                    // rootNavigator: true,
                  ).pop(true);
                  //  addData();
                });
              },
              child: Text(
                'Upload',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  showUnsavedDialog({bool clickedSubmit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: detetectedCircumstance == 'Only project status updated'
              ? Center(child: Text('Submit Status Change?'))
              : detetectedCircumstance == 'Other changes with status change'
                  ? Center(child: Text('Confirm Changes?'))
                  : Center(child: Text('No Changes Made')),
          content: Text(
              'New status: "${projectstatus.toUpperCase()}"\nOld status: "${currentProjectStatus.toUpperCase()}"'),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () async {
                      if (projectstatus.toUpperCase() ==
                          "COMPLETED") if (_name.text == ' ') {
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                          msg: 'Please Enter Name for project',
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      // Navigator.pop(context, true);
                      setState(() {
                        fromDailog = true;
                        Navigator.of(
                          context,
                          // rootNavigator: true,
                        ).pop(true);
                        addData();
                      });
                      if (currentProjectStatus == 'needs ordering') {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('lastNeedOrderingProjectName');
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (clickedSubmit) {
                        Navigator.of(context).pop();
                      } else {
                        if (currentProjectStatus == 'needs ordering') {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('lastNeedOrderingProjectName');
                        }
                        // Navigator.pop(context, false);
                        Navigator.of(
                          context,
                          // rootNavigator: true,
                        ).pop(true);
                        Navigator.pop(context, onbackpress);
                      }
                    },
                    child: clickedSubmit
                        ? Text('Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red))
                        : Text('Exit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showUnsavedDialog1({bool clickedSubmit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: detetectedCircumstance == 'Other changes without status change'
              ? Center(child: Text('Confirm Changes?'))
              : Center(child: Text('No Changes Made')),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () async {
                      if (projectstatus.toUpperCase() ==
                          "COMPLETED") if (_name.text == ' ') {
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                          msg: 'Please Enter Name for project',
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                        );
                        return;
                      }
                      if (currentProjectStatus == 'needs ordering') {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('lastNeedOrderingProjectName');
                      }
                      // Navigator.pop(context, true);
                      setState(() {
                        fromDailog = true;
                        Navigator.of(
                          context,
                          // rootNavigator: true,
                        ).pop(true);
                        addData();
                      });
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (clickedSubmit) {
                        Navigator.of(context).pop();
                      } else {
                        if (currentProjectStatus == 'needs ordering') {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('lastNeedOrderingProjectName');
                        }
                        // Navigator.pop(context, false);
                        Navigator.of(
                          context,
                          // rootNavigator: true,
                        ).pop(true);
                        Navigator.pop(context, onbackpress);
                      }
                    },
                    child: clickedSubmit
                        ? Text('Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red))
                        : Text('Exit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showEstimateDialog() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          int selectedRadio;
          if (projectstatus == 'needs estimate') {
            selectedRadio = 0;
          } else if (projectstatus == 'waiting approval') {
            selectedRadio = 1;
          } else if (projectstatus == 'needs ordering') {
            selectedRadio = 0;
          } else {
            selectedRadio = 1;
          }
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            title: projectstatus == 'needs estimate' ||
                    projectstatus == 'waiting approval'
                ? Text('Estimate Status')
                : Text('Order Status'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(
                      projectstatus == 'needs estimate' ||
                              projectstatus == 'waiting approval'
                          ? estimateStatus.length
                          : orderStatus.length, (int index) {
                    return RadioListTile(
                      value: index,
                      title: projectstatus == 'needs estimate' ||
                              projectstatus == 'waiting approval'
                          ? Text(makeFirstLetterCapital(estimateStatus[index]))
                          : Text(makeFirstLetterCapital(orderStatus[index])),
                      groupValue: selectedRadio,
                      onChanged: (int value) {
                        setState(() {
                          selectedRadio = value;
                          if (projectstatus == 'needs estimate' ||
                              projectstatus == 'waiting approval') {
                            projectstatus = estimateStatus[index];
                            print(projectstatus);
                          } else {
                            projectstatus = orderStatus[index];
                            print(projectstatus);
                          }
                        });
                      },
                    );
                  }),
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  // Navigator.pop(context, false);
                  setState(() {
                    Navigator.of(
                      context,
                      // rootNavigator: true,
                    ).pop(true);
                  });
                  Navigator.pop(context, onbackpress);
                },
                child: Text('Exit'),
              ),
              FlatButton(
                onPressed: () {
                  // Navigator.pop(context, true);
                  setState(() {
                    Navigator.of(
                      context,
                      // rootNavigator: true,
                    ).pop(true);
                    addData();
                  });
                },
                child: Text('Submit'),
              ),
            ],
          );
        });
  }

  void copiedTextToClipboard(String text) {
    Fluttertoast.showToast(
      msg: '$text copied to clipboard',
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    //  Navigator.pop(context,true);
    Future<void> _launched;
    String _phone = '';
    Future<void> _makePhoneCall(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: _email.text == null ? '' : _email.text,
        queryParameters: {'subject': 'AqGlass'});
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
          title: Text(widget.tabName),
          backgroundColor: Color(0xff669cb2),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back), onPressed: () => onback()),
        ),
        body: data == null || data.length == 0
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                physics: ScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Container(
                          margin:
                              const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 16.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: Colors.white),
                          padding: EdgeInsets.only(
                              top: 8.0, left: 10.0, right: 10.0),
                          child: Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Client Details',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[_getEditIcon()],
                                  )
                                ],
                              ),
                              InkWell(
                                onLongPress: () {
                                  Clipboard.setData(
                                      ClipboardData(text: "${_name.text}"));
                                  copiedTextToClipboard('Name');
                                },
                                onTap: () {},
                                child: Container(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      icon: Icon(
                                        FontAwesomeIcons.userCircle,
                                        color: Color(0xff669cb2),
                                      ),
                                      // hintText: 'First Name',
                                      labelText: 'Name',
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: _name,
                                    enabled: !_status,
                                    autofocus: !_status,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onLongPress: () {
                                  Clipboard.setData(
                                      ClipboardData(text: "${_mobno.text}"));
                                  copiedTextToClipboard('Phone No');
                                },
                                onTap: () {
                                  String mob = _mobno.text;
                                  _launched = _makePhoneCall('tel:$mob');
                                },
                                child: TextField(
                                  maxLength: 14,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    filled: true,
                                    icon: Icon(
                                      FontAwesomeIcons.phoneSquareAlt,
                                      color: Color(0xff669cb2),
                                    ),
                                    labelText: 'Phone No',
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  controller: _mobno,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onLongPress: () {
                                  Clipboard.setData(
                                      ClipboardData(text: "${_email.text}"));
                                  copiedTextToClipboard('Email');
                                },
                                onTap: () {
                                  setState(() {
                                    launch(_emailLaunchUri.toString());
                                  });
                                },
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    icon: Icon(
                                      Icons.email,
                                      color: Color(0xff669cb2),
                                    ),
                                    hintText: 'Enter a email address',
                                    labelText: 'Email',
                                  ),
                                  maxLines: 1,
                                  enabled: !_status,
                                  autofocus: !_status,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _email,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onLongPress: () {
                                  Clipboard.setData(
                                      ClipboardData(text: "${_address.text}"));
                                  copiedTextToClipboard('Address');
                                },
                                onTap: () {
                                  MapsLauncher.launchQuery(_address.text);
                                },
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    icon: Icon(
                                      FontAwesomeIcons.city,
                                      color: Color(0xff669cb2),
                                    ),
                                    hintText: 'Enter a Address',
                                    labelText: 'Address',
                                  ),
                                  minLines: 1,
                                  maxLines: 4,
                                  enabled: !_status,
                                  autofocus: !_status,
                                  controller: _address,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 35),
                                child: TextFormField(
                                  controller: _notes,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 2,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: 'Measurements Notes',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 20.0,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      hintText: 'Measurements Notes'),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 150),
                                child: Container(
                                  height: 40,
                                  child: RaisedButton(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3)),
                                    color: Color(0xff669cb2),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Measure Details',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      print(measureTime);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewMeasure(
                                            inspectiondate: inspectiondate,
                                            inspectionperson: inspectionperson,
                                            inspectionstatus: inspectionstatus,
                                            measureTime: measureTime,
                                            projectStatus: projectstatus,
                                            allImageList: allImages,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              showMeasure
                                  ? Column(
                                      children: <Widget>[
                                        Center(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 70),
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
                                              onTap: () {
                                                _pickDate();
                                              },
                                              child: Container(
                                                height: 50,
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        color: inspectiondate ==
                                                                null
                                                            ? Colors.red
                                                            : Color(
                                                                0xff669cb2))),
                                                child: Row(
                                                  children: <Widget>[
                                                    Center(
                                                        child: Icon(
                                                      FontAwesomeIcons
                                                          .calendarAlt,
                                                      size: 18,
                                                      color: Color(0xff669cb2),
                                                    )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Center(
                                                        child: Text(
                                                      inspectiondate == null
                                                          ? 'Select Date'
                                                          : '$inspectiondate',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    )),
                                                    Center(
                                                        child: Icon(
                                                      Icons.arrow_drop_down,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _pickTime();
                                              },
                                              child: Container(
                                                height: 50,
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        color: measureTime ==
                                                                null
                                                            ? Colors.red
                                                            : Color(
                                                                0xff669cb2))),
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
                                                      measureTime == null
                                                          ? 'Set'
                                                          : '$measureTime',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    )),
                                                    Center(
                                                        child: Icon(
                                                      Icons.arrow_drop_down,
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
                                            padding: const EdgeInsets.only(
                                                right: 70),
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
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: Container(
                                              width: 500,
                                              margin:
                                                  EdgeInsets.only(right: 55),
                                              padding: const EdgeInsets.only(
                                                  left: 35.0, right: 10.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      color:
                                                          inspectionpersonid ==
                                                                  null
                                                              ? Colors.red
                                                              : _colors1[
                                                                  statusno])),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                    hint: Text(
                                                        'Project Assigned to'),
                                                    value: inspectionpersonid ==
                                                            null
                                                        ? inspectionpersonid =
                                                            '001'
                                                        : inspectionpersonid,
                                                    iconEnabledColor:
                                                        Colors.black,
                                                    iconDisabledColor:
                                                        Colors.grey,
                                                    icon: measureemp == null ||
                                                            measureemp.length ==
                                                                0
                                                        ? Icon(
                                                            Icons.restore,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                          ),
                                                    items:
                                                        measureemp?.map((item) {
                                                              //  itemid=item['id'];
                                                              bool value = item[
                                                                  'assigned'];
                                                              return DropdownMenuItem(
                                                                value:
                                                                    item['id'],
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    value
                                                                        ? Text(
                                                                            '${item['name']}',
                                                                            style:
                                                                                TextStyle(color: Colors.red),
                                                                          )
                                                                        : Text(
                                                                            '${item['name']}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.green,
                                                                            )),
                                                                  ],
                                                                ),
                                                              );
                                                            })?.toList() ??
                                                            [],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        inspectionpersonid =
                                                            value;
                                                        detectChanges = true;

                                                        print(
                                                            inspectionpersonid);
                                                      });
                                                    }),
                                              ),
                                            )),
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Padding(
                                        //     padding: const EdgeInsets.only(
                                        //         right: 110),
                                        //     child: Text(
                                        //       'Measurement Status *',
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.w500,
                                        //           fontSize: 17),
                                        //     )),
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Padding(
                                        //     padding:
                                        //         const EdgeInsets.only(left: 30),
                                        //     child: Container(
                                        //       width: 500,
                                        //       margin:
                                        //           EdgeInsets.only(right: 55),
                                        //       padding: const EdgeInsets.only(
                                        //           left: 35.0, right: 10.0),
                                        //       decoration: BoxDecoration(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   10.0),
                                        //           border: Border.all(
                                        //               color:
                                        //                   _colors1[statusno])),
                                        //       child:
                                        //           DropdownButtonHideUnderline(
                                        //         child: DropdownButton(
                                        //             hint: Text(
                                        //                 'Measurement Status'),
                                        //             value:
                                        //                 inspectionstatus == null
                                        //                     ? inspectionstatus =
                                        //                         'select status'
                                        //                     : inspectionstatus,
                                        //             items: measureStatus
                                        //                     ?.map((item) {
                                        //                   return DropdownMenuItem(
                                        //                     value: item,
                                        //                     child: Row(
                                        //                       children: <
                                        //                           Widget>[
                                        //                         new Text(
                                        //                             '${toBeginningOfSentenceCase(item.toString())}'),
                                        //                       ],
                                        //                     ),
                                        //                   );
                                        //                 })?.toList() ??
                                        //                 [],
                                        //             onChanged: (value) {
                                        //               setState(() {
                                        //                 inspectionstatus =
                                        //                     value;
                                        //                 if (value ==
                                        //                     'assigned') {
                                        //                   statusno = 0;
                                        //                 } else if (value ==
                                        //                     'completed') {
                                        //                   statusno = 2;
                                        //                 } else if (value ==
                                        //                     'incomplete') {
                                        //                   statusno = 1;
                                        //                 } else {
                                        //                   statusno = 3;
                                        //                 }

                                        //                 print(inspectionstatus);
                                        //               });
                                        //             }),
                                        //       ),
                                        //     )),
                                      ],
                                    )
                                  : SizedBox(),
                              showInstall
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              showInstall
                                  ? Column(
                                      children: <Widget>[
                                        Center(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 80),
                                              child: Text(
                                                'Installation Date & Time *',
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
                                              onTap: () {
                                                _pickDate();
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 160,
                                                margin:
                                                    EdgeInsets.only(left: 30),
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        color: assigneddate ==
                                                                null
                                                            ? Colors.red
                                                            : Color(
                                                                0xff669cb2))),
                                                child: Row(
                                                  children: <Widget>[
                                                    Center(
                                                        child: Icon(
                                                      FontAwesomeIcons
                                                          .calendarAlt,
                                                      size: 18,
                                                      color: Color(0xff669cb2),
                                                    )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Center(
                                                        child: Text(
                                                      assigneddate == null
                                                          ? 'Select Date'
                                                          : '$assigneddate',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    )),
                                                    Center(
                                                        child: Icon(
                                                      Icons.arrow_drop_down,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _pickTime();
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 115,
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        color: installTime ==
                                                                null
                                                            ? Colors.red
                                                            : Color(
                                                                0xff669cb2))),
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
                                                      installTime == null
                                                          ? 'Set'
                                                          : installTime,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    )),
                                                    Center(
                                                        child: Icon(
                                                      Icons.arrow_drop_down,
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
                                            padding: const EdgeInsets.only(
                                                right: 80),
                                            child: Text(
                                              'Installation Assigned To *',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17),
                                            )),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: Container(
                                              width: 500,
                                              margin:
                                                  EdgeInsets.only(right: 55),
                                              padding: const EdgeInsets.only(
                                                  left: 35.0, right: 10.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      color:
                                                          assignedtopersonid ==
                                                                  null
                                                              ? Colors.red
                                                              : _colors3[
                                                                  installno])),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                    hint: Text(
                                                        'Project Assigned to'),
                                                    value: assignedtopersonid ==
                                                            null
                                                        ? assignedtopersonid =
                                                            '001'
                                                        : assignedtopersonid,
                                                    iconEnabledColor:
                                                        Colors.black,
                                                    iconDisabledColor:
                                                        Colors.grey,
                                                    icon: installemp == null ||
                                                            installemp.length ==
                                                                0
                                                        ? Icon(
                                                            Icons.restore,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                          ),
                                                    items:
                                                        installemp?.map((item) {
                                                              //  itemid=item['id'];
                                                              bool value = item[
                                                                  'assigned'];
                                                              return DropdownMenuItem(
                                                                value:
                                                                    item['id'],
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    value
                                                                        ? Text(
                                                                            '${item['name']}',
                                                                            style:
                                                                                TextStyle(color: Colors.red),
                                                                          )
                                                                        : Text(
                                                                            '${item['name']}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.green,
                                                                            )),
                                                                  ],
                                                                ),
                                                              );
                                                            })?.toList() ??
                                                            [],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        assignedtopersonid =
                                                            value;
                                                        detectChanges = true;
                                                      });
                                                    }),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        // Padding(
                                        //     padding: const EdgeInsets.only(
                                        //         right: 125),
                                        //     child: Text(
                                        //       'Installation Status *',
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.w500,
                                        //           fontSize: 17),
                                        //     )),
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Padding(
                                        //     padding:
                                        //         const EdgeInsets.only(left: 30),
                                        //     child: Container(
                                        //       width: 500,
                                        //       margin:
                                        //           EdgeInsets.only(right: 55),
                                        //       padding: const EdgeInsets.only(
                                        //           left: 35.0, right: 10.0),
                                        //       decoration: BoxDecoration(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   10.0),
                                        //           border: Border.all(
                                        //               color:
                                        //                   _colors3[installno])),
                                        //       child:
                                        //           DropdownButtonHideUnderline(
                                        //         child: DropdownButton(
                                        //             hint: Text(
                                        //                 'Installation Status'),
                                        //             value: installationstatus ==
                                        //                     null
                                        //                 ? installationstatus =
                                        //                     'select status'
                                        //                 : installationstatus,
                                        //             items: status?.map((item) {
                                        //                   return DropdownMenuItem(
                                        //                     value: item,
                                        //                     child: Row(
                                        //                       children: <
                                        //                           Widget>[
                                        //                         new Text(
                                        //                             '${toBeginningOfSentenceCase(item.toString())}'),
                                        //                       ],
                                        //                     ),
                                        //                   );
                                        //                 })?.toList() ??
                                        //                 [],
                                        //             onChanged: (value) {
                                        //               setState(() {
                                        //                 installationstatus =
                                        //                     value;
                                        //                 if (installationstatus ==
                                        //                     'assigned') {
                                        //                   installno = 0;
                                        //                 } else if (installationstatus ==
                                        //                     'completed') {
                                        //                   installno = 2;
                                        //                 } else if (installationstatus ==
                                        //                     'incomplete') {
                                        //                   installno = 1;
                                        //                 } else if (installationstatus ==
                                        //                     'paid') {
                                        //                   installno = 3;
                                        //                 } else {
                                        //                   installno = 4;
                                        //                 }

                                        //                 print(
                                        //                     installationstatus);
                                        //               });
                                        //             }),
                                        //       ),
                                        //     )),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 155),
                                child: Text(
                                  'Project Status *',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
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
                                  child: !widget.projectStatus
                                          .contains(projectstatus)
                                      ? Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                              toBeginningOfSentenceCase(
                                                  projectstatus),
                                              style: TextStyle(fontSize: 16)),
                                        )
                                      : DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              hint: Text(
                                                'Project Status',
                                              ),
                                              value: projectstatus,
                                              items: widget.projectStatus
                                                      ?.map((item) {
                                                    return DropdownMenuItem(
                                                      value: item,
                                                      child: Row(
                                                        children: <Widget>[
                                                          new Text(
                                                              '${makeFirstLetterCapital(item.toString())}'),
                                                        ],
                                                      ),
                                                    );
                                                  })?.toList() ??
                                                  [],
                                              onChanged: (value) {
                                                setState(() {
                                                  projectstatus = value;
                                                  // detectChanges = true;
                                                  if (value ==
                                                      'needs install') {
                                                    showInstall = true;
                                                    showMeasure = false;
                                                  } else if (value ==
                                                          'install assigned' ||
                                                      value ==
                                                          'install incomplete' ||
                                                      value ==
                                                          'needs payment' ||
                                                      value == 'paid') {
                                                    setState(() {
                                                      showInstall = true;
                                                      showMeasure = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      showInstall = false;
                                                      showMeasure = true;
                                                    });
                                                  }
                                                  print(
                                                      'Project Status Updated: $projectstatus');
                                                });
                                              }),
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              widget.tabName == 'Install'
                                  ? Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: Color(0xff669cb2),
                                      )),
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      child: Row(
                                        children: [
                                          RaisedButton(
                                            padding: EdgeInsets.all(0),
                                            color: Color(0xff669cb2),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            onPressed: () {
                                              _openInvoice();
                                            },
                                            child: Text(
                                              'Upload Invoice',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: invoiceUrl == null ||
                                                    invoiceUrl == ''
                                                ? Text('No File Chosen')
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                    child: FlatButton(
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Invoice(
                                                                        invoiceUrl:
                                                                            invoiceUrl,
                                                                        id: widget
                                                                            .id,
                                                                      )),
                                                        ).then((value) {
                                                          if (value == true) {
                                                            setState(() {
                                                              isload = true;
                                                              getData();
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            "View Invoice",
                                                            style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationThickness:
                                                                    2,
                                                                color: Color(
                                                                    0xff669cb2),
                                                                fontSize: 15),
                                                          ),
                                                          Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              size: 12,
                                                              color: Color(
                                                                  0xff669cb2))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              Container(
                                padding: EdgeInsets.all(10),
                                height: 216,
                                child: VerticalTabs(
                                    selectedTabBackgroundColor:
                                        Color(0xff669cb2),
                                    backgroundColor: Colors.grey[100],
                                    contentScrollAxis: Axis.horizontal,
                                    //indicatorColor: Colors.black,
                                    indicatorSide: IndicatorSide.end,
                                    tabsElevation: 5,
                                    tabsWidth: 100,
                                    tabs: [
                                      Tab(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Layout Images'),
                                        ),
                                      ),
                                      Tab(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Order Images'),
                                        ),
                                      ),
                                      Tab(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'All Images',
                                          ),
                                        ),
                                      ),
                                    ],
                                    contents: [
                                      Container(
                                        child: layoutlist == null ||
                                                layoutlist.length == 0
                                            ? Center(
                                                child: isload
                                                    ? CircularProgressIndicator()
                                                    : Text(
                                                        'Images is not available'),
                                              )
                                            : Swiper(
                                                itemCount: layoutlist.length,
                                                layout: layoutlist.length == 1
                                                    ? SwiperLayout.DEFAULT
                                                    : SwiperLayout.STACK,
                                                itemWidth: 180,
                                                loop: false,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                onTap: (index) {
                                                  Navigator.of(context)
                                                      .push(
                                                    new MaterialPageRoute(
                                                      builder: (_) =>
                                                          UploadedGrid(
                                                        imageList: layoutlist,
                                                        name: 'layout',
                                                      ),
                                                    ),
                                                  )
                                                      .then((value) {
                                                    if (value == true) {
                                                      setState(() {
                                                        isload = true;
                                                        getData();
                                                      });
                                                    }
                                                  });
                                                },
                                                itemBuilder: (context, index) =>
                                                    Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    child: layoutlist[index]
                                                                ['imageUrl'] ==
                                                            null
                                                        ? Center(
                                                            child: Text(
                                                                "No Image"))
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                layoutlist[
                                                                        index][
                                                                    'imageUrl'],
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Center(
                                                              child: SizedBox(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                                height: 20.0,
                                                                width: 20.0,
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),

                                                    // Image.network(
                                                    //     layoutlist[index][
                                                    //         'imageUrl'])
                                                  ),
                                                ),
                                              ),
                                      ),
                                      Container(
                                        child: ordersList == null ||
                                                ordersList.length == 0
                                            ? Center(
                                                child: isload
                                                    ? CircularProgressIndicator()
                                                    : Text(
                                                        'Images is not available'),
                                              )
                                            : Swiper(
                                                itemCount: ordersList.length,
                                                layout: ordersList.length == 1
                                                    ? SwiperLayout.DEFAULT
                                                    : SwiperLayout.STACK,
                                                itemWidth: 180,
                                                loop: false,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                onTap: (index) {
                                                  Navigator.of(context)
                                                      .push(
                                                    new MaterialPageRoute(
                                                      builder: (_) =>
                                                          UploadedGrid(
                                                        imageList: ordersList,
                                                        name: 'orders',
                                                      ),
                                                    ),
                                                  )
                                                      .then((value) {
                                                    if (value == true) {
                                                      setState(() {
                                                        isload = true;
                                                        getData();
                                                      });
                                                    }
                                                  });
                                                },
                                                itemBuilder: (context, index) =>
                                                    Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: ordersList[index]
                                                              ['imageUrl'] ==
                                                          null
                                                      ? Center(
                                                          child:
                                                              Text("No Image"))
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              ordersList[index]
                                                                  ['imageUrl'],
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
                                                  // ordersList[index]
                                                  //     ['imageUrl']),
                                                ),
                                              ),
                                      ),
                                      Container(
                                        child: allImages == null ||
                                                allImages.length == 0
                                            ? Center(
                                                child: Text(
                                                    'Images is not available'),
                                              )
                                            : Swiper(
                                                itemCount: allImages.length,
                                                layout: allImages.length == 1
                                                    ? SwiperLayout.DEFAULT
                                                    : SwiperLayout.STACK,
                                                itemWidth: 180,
                                                autoplay: false,
                                                loop: false,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                onTap: (index) {
                                                  Navigator.of(context).push(
                                                    new MaterialPageRoute(
                                                      builder: (_) =>
                                                          UploadedGrid(
                                                        imageList: allImages,
                                                        name: 'All Images',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemBuilder: (context, index) =>
                                                    Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    child: allImages[index]
                                                                ['imageUrl'] ==
                                                            null
                                                        ? Center(
                                                            child: Text(
                                                                "No Image"))
                                                        : CachedNetworkImage(
                                                            imageUrl: allImages[
                                                                    index]
                                                                ['imageUrl'],
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Center(
                                                              child: SizedBox(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                                height: 20.0,
                                                                width: 20.0,
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                    // Image.network(
                                                    // allImages[index][
                                                    //     'imageUrl'])
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              widget.tabName == 'Current Project'
                                  ? SizedBox()
                                  : Row(
                                      children: [
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              height: 40,
                                              child: RaisedButton.icon(
                                                  onPressed: () {
                                                    check = false;
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    this
                                                        ._scaffoldKey
                                                        .currentState
                                                        .showBottomSheet((ctx) =>
                                                            _buildBottomSheet(
                                                                ctx));
                                                  },
                                                  color: Color(0xff669cb2),
                                                  icon: Icon(
                                                    Icons.add_a_photo,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    "Layout Image",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 40,
                                          child: RaisedButton.icon(
                                              color: Color(0xff669cb2),
                                              onPressed: () {
                                                check = true;
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                this
                                                    ._scaffoldKey
                                                    .currentState
                                                    .showBottomSheet((ctx) =>
                                                        _buildBottomSheet(ctx));
                                              },
                                              icon: Icon(
                                                Icons.add_a_photo,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              label: Text("Order Image",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  images.length != 0
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(
                                                  new MaterialPageRoute(
                                                    builder: (_) => ImageGrid(
                                                      imageList: images,
                                                      name: 'Layout Images',
                                                    ),
                                                  ),
                                                )
                                                .then((val) => val
                                                    ? _getRequests()
                                                    : null);
                                          },
                                          child: Container(
                                            child: Text("Captured Images",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationThickness: 2,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff669cb2),
                                                    fontSize: 15)),
                                          ),
                                        )

                                      //   ), FlatButton(
                                      //   onPressed: () {
                                      //     print(images);
                                      //     Navigator.of(context)
                                      //         .push(
                                      //           new MaterialPageRoute(
                                      //             builder: (_) => ImageGrid(
                                      //               imageList: images,
                                      //               name: 'Layout Images',
                                      //             ),
                                      //           ),
                                      //         )
                                      //         .then((val) => val
                                      //             ? _getRequests()
                                      //             : null);
                                      //   },
                                      //   child: Text(
                                      //     "Captured Images",
                                      //   ),
                                      //   // style: TextStyle(
                                      //   //     fontWeight: FontWeight.bold,
                                      //   //     fontSize: 18),
                                      // )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  images.length != 0
                                      ? Icon(Icons.arrow_forward_ios,
                                          size: 16, color: Color(0xff669cb2))
                                      : SizedBox(),
                                  Spacer(),
                                  images1.length != 0
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(
                                                    new MaterialPageRoute(
                                                      builder: (_) => ImageGrid(
                                                        imageList: images1,
                                                        name: 'Orders Images',
                                                      ),
                                                    ),
                                                  )
                                                  .then((val) => val
                                                      ? _getRequests()
                                                      : null);
                                            },
                                            child: Container(
                                              child: Text("Captured Images",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationThickness: 2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff669cb2),
                                                      fontSize: 15)),
                                            ),
                                          ))
                                      //   FlatButton(
                                      //   onPressed: () {
                                      //     Navigator.of(context)
                                      //         .push(
                                      //           new MaterialPageRoute(
                                      //             builder: (_) => ImageGrid(
                                      //               imageList: images1,
                                      //               name: 'Orders Images',
                                      //             ),
                                      //           ),
                                      //         )
                                      //         .then((val) => val
                                      //             ? _getRequests()
                                      //             : null);
                                      //   },

                                      // )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  images1.length != 0
                                      ? Icon(Icons.arrow_forward_ios,
                                          size: 16, color: Color(0xff669cb2))
                                      : SizedBox(),
                                ],
                              ),

                              // Row(
                              //   children: <Widget>[
                              //     SizedBox(
                              //       width: 150.0,
                              //       height: 150.0,
                              //       child: DecoratedBox(
                              //           decoration: const BoxDecoration(
                              //             color: Color(0xff669cb2),
                              //           ),
                              //           child: Center(
                              //             child: Column(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               children: <Widget>[
                              //                 IconButton(
                              //                   onPressed: () {
                              //                     check = false;
                              //                     FocusScope.of(context)
                              //                         .requestFocus(
                              //                             FocusNode());
                              //                     this
                              //                         ._scaffoldKey
                              //                         .currentState
                              //                         .showBottomSheet((ctx) =>
                              //                             _buildBottomSheet(
                              //                                 ctx));
                              //                   },
                              //                   iconSize: 30,
                              //                   color: Colors.white,
                              //                   icon: Icon(
                              //                     Icons.add_a_photo,
                              //                   ),
                              //                 ),
                              //                 Text(
                              //                   "Layout",
                              //                   style: TextStyle(
                              //                       color: Colors.white,
                              //                       fontWeight: FontWeight.bold,
                              //                       fontSize: 15),
                              //                 ),
                              //                 SizedBox(
                              //                   height: 15,
                              //                 ),
                              //                 layoutlist.length != 0
                              //                     ? GestureDetector(
                              //                         onTap: () {
                              //                           Navigator.of(context)
                              //                               .push(
                              //                             new MaterialPageRoute(
                              //                               builder: (_) =>
                              //                                   UploadedGrid(
                              //                                 imageList:
                              //                                     layoutlist,
                              //                                 name: 'layout',
                              //                               ),
                              //                             ),
                              //                           );
                              //                         },
                              //                         child: Container(
                              //                           child: Row(
                              //                             mainAxisAlignment:
                              //                                 MainAxisAlignment
                              //                                     .center,
                              //                             crossAxisAlignment:
                              //                                 CrossAxisAlignment
                              //                                     .center,
                              //                             children: <Widget>[
                              //                               Text(
                              //                                 'Uploaded Images',
                              //                                 style: TextStyle(
                              //                                     color: Colors
                              //                                         .white,
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .bold),
                              //                               ),
                              //                               Icon(
                              //                                 Icons
                              //                                     .navigate_next,
                              //                                 color:
                              //                                     Colors.white,
                              //                               )
                              //                             ],
                              //                           ),
                              //                         ),
                              //                       )
                              //                     : SizedBox(),
                              //               ],
                              //             ),
                              //           )),
                              //     ),
                              //     Spacer(),
                              //     SizedBox(
                              //       width: 150.0,
                              //       height: 150.0,
                              //       child: DecoratedBox(
                              //           decoration: const BoxDecoration(
                              //               color: Color(0xff669cb2)),
                              //           child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             children: <Widget>[
                              //               IconButton(
                              //                 onPressed: () {
                              //                   check = true;
                              //                   FocusScope.of(context)
                              //                       .requestFocus(FocusNode());
                              //                   this
                              //                       ._scaffoldKey
                              //                       .currentState
                              //                       .showBottomSheet((ctx) =>
                              //                           _buildBottomSheet(ctx));
                              //                 },
                              //                 iconSize: 30,
                              //                 color: Colors.white,
                              //                 icon: Icon(
                              //                   Icons.add_a_photo,
                              //                 ),
                              //               ),
                              //               Text(
                              //                 "Orders",
                              //                 style: TextStyle(
                              //                   color: Colors.white,
                              //                   fontWeight: FontWeight.bold,
                              //                   fontSize: 15,
                              //                 ),
                              //               ),
                              //               SizedBox(
                              //                 height: 15,
                              //               ),
                              //               ordersList.length != 0
                              //                   ? GestureDetector(
                              //                       onTap: () {
                              //                         Navigator.of(context)
                              //                             .push(
                              //                           new MaterialPageRoute(
                              //                             builder: (_) =>
                              //                                 UploadedGrid(
                              //                               imageList:
                              //                                   ordersList,
                              //                               name: 'order',
                              //                             ),
                              //                           ),
                              //                         );
                              //                       },
                              //                       child: Container(
                              //                         child: Row(
                              //                           mainAxisAlignment:
                              //                               MainAxisAlignment
                              //                                   .center,
                              //                           crossAxisAlignment:
                              //                               CrossAxisAlignment
                              //                                   .center,
                              //                           children: <Widget>[
                              //                             Text(
                              //                               'Uploaded Images',
                              //                               style: TextStyle(
                              //                                   color: Colors
                              //                                       .white,
                              //                                   fontWeight:
                              //                                       FontWeight
                              //                                           .bold),
                              //                             ),
                              //                             Icon(
                              //                               Icons.navigate_next,
                              //                               color: Colors.white,
                              //                             )
                              //                           ],
                              //                         ),
                              //                       ),
                              //                     )
                              //                   : SizedBox()
                              //             ],
                              //           )),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 5,
                              ),
                              widget.tabName == 'Current Project'
                                  ? SizedBox()
                                  : Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            width: 150,
                                            margin: EdgeInsets.all(4),
                                            child: new RaisedButton(
                                              child: new Text("Submit"),
                                              textColor: Colors.white,
                                              color: Colors.blueGrey,
                                              onPressed: () {
                                                if (assignedtopersonid ==
                                                    '001') {
                                                  Fluttertoast.showToast(
                                                    msg: 'Please Assign team',
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                  );
                                                  return;
                                                }
                                                setState(() {
                                                  if (showMeasure == true) {
                                                    if (assignedtopersonid !=
                                                                '001' &&
                                                            inspectiondate ==
                                                                null ||
                                                        measureTime == null) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Please Select Date & Time",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    } else {
                                                      val1 = false;
                                                      // detectChanges = false;
                                                      preInitializationForCircumstanceDetection();
                                                      checkCircumstances(
                                                          clickedSubmit: true);
                                                      // showsavedDialog();
                                                    }
                                                  } else if (showInstall ==
                                                      true) {
                                                    if (assignedtopersonid !=
                                                                '001' &&
                                                            assigneddate ==
                                                                null ||
                                                        installTime == null) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Please Select Date & Time",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    } else {
                                                      val1 = false;
                                                      // showsavedDialog();
                                                      // detectChanges = false;
                                                      preInitializationForCircumstanceDetection();
                                                      checkCircumstances(
                                                          clickedSubmit: true);
                                                    }
                                                  }
                                                });
                                              },
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0)),
                                            )),
                                      ],
                                    ),
                              widget.tabName == 'Current Project'
                                  ? SizedBox()
                                  : Center(
                                      child: Text(
                                      "* Click on Submit button to Save all the changes.",
                                      style: detectChanges == true
                                          ? TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)
                                          : TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                    )),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
        // bottomNavigationBar: new Container(
        //   color: Colors.white.withOpacity(1),
        //   padding: EdgeInsets.all(5),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     children: <Widget>[
        //       Expanded(
        //           flex: 1,
        //           child: StepProgressIndicator(
        //               totalSteps: 3,
        //               currentStep: _currentValue,
        //               size: 10,
        //               selectedColor: Color(0xff44aae4),
        //               unselectedColor: Color(0xff69737f),
        //               customColor: (index) => index == 0
        //                   ? Colors.yellow[700]
        //                   : index == 2
        //                       ? paid ? Colors.green : Colors.grey[200]
        //                       : _colors[i],
        //               customStep: (index, color, _) => index == 0
        //                   ? Container(
        //                       color: color,
        //                     )
        //                   : Container(
        //                       color: color,
        //                     ))),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Container _buildBottomSheet(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        // height: 300,
        constraints: BoxConstraints(minHeight: 100, maxHeight: 150),
        // padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff669cb2), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.green[50].withOpacity(0.7),
                        child: IconButton(
                          padding: EdgeInsets.all(15.0),
                          icon: Icon(FontAwesomeIcons.cameraRetro),
                          color: Color(0xff669cb2),
                          iconSize: 30.0,
                          onPressed: () {
                            // Navigator.of(context).pop();
                            // files.clear();
                            // print(files);
                            check ? getImage1() : getImage();
                          },
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('Camera',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.green[50].withOpacity(0.7),
                        child: IconButton(
                          padding: EdgeInsets.all(15.0),
                          icon: Icon(FontAwesomeIcons.photoVideo),
                          color: Color(0xff669cb2),
                          iconSize: 30.0,
                          onPressed: () {
                            // Navigator.of(context).pop();
                            // files.clear();
                            // print(files);
                            check ? _openFileExplorer1() : _openFileExplorer();
                          },
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('Gallery',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold))
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  cureentDateTime() {
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    selectedDateTime = DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, time.hour, time.minute);

    final String formatted = finalDate.format(selectedDateTime);
    addEmployee(formatted);
    installerusers(formatted);
//   if(inspectiondate==null){
//  inspectiondate='$formatted';
//   }
  }

  var measuredate, installdate;
  _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDate: pickedDate,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 500,
                  width: 600,
                  child: child,
                ),
              ],
            ),
          );
        });
    if (date != null)
      setState(() {
        // _selecteditem1=null;
        FocusScope.of(context).requestFocus(new FocusNode());
        pickedDate = date;
        selectedDateTime = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, time.hour, time.minute);
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(selectedDateTime);
        // something like 2013-04-20
        //  addEmployee(formatted);
        showMeasure
            ? inspectiondate = '$formatted'
            : assigneddate = '$formatted';
        if (showMeasure == true) {
          inspectionpersonid = null;
          measureemp.clear();
          DateTime date = formatter.parse(selectedDateTime.toString());
          measuredate = finalDate.format(date);
          print(measuredate);
          measureTime = null;
          detectChanges = true;
          Fluttertoast.showToast(
              msg: "Please Set time",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          //  addEmployee(measuredate);
        } else if (showMeasure == false) {
          setState(() {
            detectChanges = true;
            assignedtopersonid = null;
            installTime = null;
            installdate = selectedDateTime;
            installemp.clear();
            DateTime date = formatter.parse(selectedDateTime.toString());
            installdate = finalDate.format(date);
          });

          Fluttertoast.showToast(
              msg: "Please Set time",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          // installerusers(installdate);
        }
      });
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        FocusScope.of(context).requestFocus(new FocusNode());
        time = t;
        selectedDateTime = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, time.hour, time.minute);
        if (showMeasure == true) {
          inspectionpersonid = null;
          measureemp.clear();
          detectChanges = true;
          //  DateTime date =formatter.parse(selectedDateTime.toString());
          measuredate = finalDate.format(selectedDateTime);
          measureTime = DateFormat.Hm().format(selectedDateTime);
          print(measuredate);
          print('detectChanges: $detectChanges');
          addEmployee(measuredate);
        } else {
          assignedtopersonid = null;
          installemp.clear();
          detectChanges = true;
          installdate = finalDate.format(selectedDateTime);
          installTime = DateFormat.Hm().format(selectedDateTime);
          installerusers(installdate);
        }
      });
  }

  List employee, installer;
  addEmployee(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/inspectionusers';
    Map data = {'date': '$date'};
    String body = json.encode(data);
    http
        .post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> loginData = json.decode(response.body);
        //  userData=loginData;
        if (mounted) {
          setState(() {
            measureemp = loginData['inspectors'];
            measureemp.insert(
                0, {'id': '001', 'name': 'Select Team', 'assigned': false});
            print(measureemp.length);
            //  print(userData[i]['name']);
            print(measureemp);
          });
          print('detectChanges: $detectChanges');
        }
      } else {
        print(response.statusCode);
      }
      print('detectChanges: $detectChanges');
    });
  }

  installerusers(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/installerusers';
    Map data = {'date': '$date'};
    String body = json.encode(data);
    http
        .post(
      url,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> loginData = json.decode(response.body);
        //  userData=loginData;
        if (mounted) {
          setState(() {
            installemp = loginData['inspectors'];
            installemp.insert(
                0, {'id': '001', 'name': 'Select Team', 'assigned': false});
            print(installemp);
            //  print(userData[i]['name']);
          });
        }
      } else {
        print(response.statusCode);
      }
    });
  }

  showsavedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text('Confirm changes?'),
          content: currentProjectStatus == projectstatus
              ? Text('Do you want to submit changes ?')
              : Text(
                  'Do you want to submit changes?\n\nNew status: "${projectstatus.toUpperCase()}"\nOld status: "${currentProjectStatus.toUpperCase()}"'),
          actions: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        // Navigator.pop(context, true);
                        setState(() {
                          Navigator.of(
                            context,
                            // rootNavigator: true,
                          ).pop(true);
                          addData();
                        });
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        // Navigator.pop(context, false);
                        Navigator.of(
                          context,
                          // rootNavigator: true,
                        ).pop(true);
                      },
                      child: Text('Exit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  sendInvoice() async {
    onbackpress = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String id = widget.id;
    print(id);
    pr.show();
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "${ApiBaseUrl.BASE_URL}/restapi/admin/uploadinvoice",
        ),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      request.headers["Content-Type"] = 'multipart/form-data';
      request.fields["projectId"] = id;
      request.files.add(
        http.MultipartFile.fromBytes(
          "invoice",
          invoice.readAsBytesSync(),
          filename: "test.${invoice.path.split(".").last}",
          contentType: MediaType("pdf", "${invoice.path.split(".").last}"),
        ),
      );
      request.send().then((onValue) {
        pr.hide();
        if (onValue.statusCode == 200) {
          getData();
          Fluttertoast.showToast(
              msg: "Invoice Uploaded.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          print(onValue.statusCode);

          Fluttertoast.showToast(
              msg: "Something Went Wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } catch (error) {
      throw error;
    }
  }

  Map data;
  List layoutlist, ordersList;
  List allImages;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String duedate,
      projectpriority,
      projectstatus,
      projecttype,
      inspectionpersonid,
      inspectionstatus,
      installationstatus,
      projectCategory,
      inspectionperson,
      inspectiondate,
      assigneddate,
      invoiceUrl,
      assignedtopersonid,
      currentProjectStatus = '';
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String id = widget.id;
    print(id);
    http.Response response = await http.get(
        '${ApiBaseUrl.BASE_URL}/restapi/admin/project/$id',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(response.statusCode);
    data = json.decode(response.body);
    try {
      if (mounted) {
        setState(() {
          isload = false;
          print(data['project']);
          String fname = data['project']['firstname'];
          String lname = data['project']['lastname'];
          _name.text = '$fname';
          _mobno.text = data['project']['phone'];
          _email.text = data['project']['email'];
          _address.text = data['project']['address'];
          _notes.text = data['project']['notes'];
          previousName = _name.text;
          previousMob = _mobno.text;
          previousEmail = _email.text;
          previousAddress = _address.text;
          previousNotes = _notes.text;
          layoutlist = data['project']['layoutslist'];
          ordersList = data['project']['orderslist'];
          duedate = data['project']['duedate'];
          assigneddate = data['project']['assigneddate'];
          inspectiondate = data['project']['inspectiondate'];
          projectpriority = data['project']['projectpriority'];
          projectstatus = data['project']['projectstatus'];
          projecttype = data['project']['projecttype'];
          invoiceUrl = data['project']['invoiceUrl'];
          inspectionpersonid = data['project']['inspectionpersonid'];
          inspectionperson = data['project']['inspectionperson'];
          inspectionstatus = data['project']['inspectionstatus'];
          installationstatus = data['project']['installationstatus'];
          if (data['project']['projectCategory'] == null) {
            projectCategory = 'ongoing';
          } else {
            projectCategory = data['project']['projectCategory'];
          }
          projectCategory = data['project']['projectCategory'];
          assignedtopersonid = data['project']['assignedtopersonid'];
          if (projectCategory == null) {
            projectCategory = 'ongoing';
          }
          if (inspectionstatus == 'assigned') {
            statusno = 0;
          } else if (inspectionstatus == 'completed') {
            statusno = 2;
          } else if (inspectionstatus == 'incomplete') {
            statusno = 1;
          } else {
            statusno = 3;
          }

          if (installationstatus == 'assigned') {
            installno = 0;
          } else if (installationstatus == 'completed') {
            installno = 2;
          } else if (installationstatus == 'incomplete') {
            installno = 1;
          } else if (installationstatus == 'paid') {
            installno = 3;
          } else {
            installno = 4;
          }

          if (widget.name == 'measure') {
            if (data['project']['inspectionstatus'] == 'completed') {
              i = 2;
            } else if (data['project']['inspectionstatus'] == 'incomplete') {
              i = 1;
            } else if (data['project']['inspectionstatus'] == 'paid') {
              i = 2;
              paid = true;
            }
          } else {
            if (data['project']['installationstatus'] == 'completed') {
              i = 2;
            } else if (data['project']['installationstatus'] == 'incomplete') {
              i = 1;
            } else if (data['project']['installationstatus'] == 'paid') {
              i = 2;
              paid = true;
            }
          }
          allImages = new List.from(layoutlist)..addAll(ordersList);

          if (inspectiondate != null) {
            var formatdate = inspectiondate.split('.');
            var dateformat = formatdate[0].split('T');
            String finaldatetime = '${dateformat[0]} ${dateformat[1]}';
            measuredate = finaldatetime;
            print(measuredate);
            DateTime date = formatter.parse(finaldatetime);
            inspectiondate = formatter.format(date);
            DateTime time1 = timeformat.parse(dateformat[1]);
            measureTime = timeformat.format(time1);
            print(measureTime);
          }
          if (assigneddate != null) {
            var formatdate = assigneddate.split('.');
            var dateformat = formatdate[0].split('T');
            String finaldatetime = '${dateformat[0]} ${dateformat[1]}';
            installdate = finaldatetime;
            DateTime date = formatter.parse(finaldatetime);
            assigneddate = formatter.format(date);
            DateTime time1 = timeformat.parse(dateformat[1]);
            installTime = timeformat.format(time1);
          }
        });

        //  goUp() ;
      }
    } catch (error) {
      print(error);
    }
  }

  showWidget() {
    if (widget.tabName == 'Measure') {
      setState(() {
        showMeasure = true;
        showInstall = false;
      });
    } else if (widget.tabName == 'Orders') {
      if (projectstatus == 'material arrived' ||
          projectstatus == 'material ready') {
        setState(() {
          showMeasure = false;
          showInstall = true;
        });
      } else {
        showMeasure = true;
        showInstall = false;
      }
    } else if (widget.tabName == 'Install') {
      setState(() {
        showMeasure = false;
        showInstall = true;
      });
    }
  }

  showGenericError() {
    Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<String> startUploadingImages(String projectId) async =>
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) =>
              StatefulDialog(projectId, newLayoutImages, newOrderImages));

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  addData() async {
    if (_email.text.isNotEmpty) if (!isValidEmail(_email.text)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Alert"),
          content: Text("Please enter valid email id."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("OK"),
            )
          ],
        ),
      );
      return;
    }
    onbackpress = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String id = widget.id;
    pr.show();
    if (assignedtopersonid == '001') {
      assignedtopersonid = null;
    }
    if (installationstatus == 'select status') {
      installationstatus = null;
    }
    if (inspectionpersonid == '001') {
      inspectionpersonid = null;
    }
    if (inspectionstatus == 'select status') {
      inspectionstatus = null;
    }

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "${ApiBaseUrl.BASE_URL}/restapi/admin/update-project",
        ),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      request.headers["Content-Type"] = 'multipart/form-data';
      request.fields["id"] = id;
      print('id: $id');
      if (_name.text != null) {
        request.fields["firstname"] = _name.text;
        print(_name.text);
      }

      if (_address.text != null) {
        request.fields["address"] = _address.text;
        print(_address.text);
      }
      if (_mobno != null) {
        request.fields["phone"] = _mobno.text;
        print(_mobno.text);
      }

      if (_email.text != null) {
        request.fields["email"] = _email.text;
        print(_email.text);
      }
      if (_notes.text != null) {
        request.fields["notes"] = _notes.text;
        print(_notes.text);
      }

      if (duedate != null) {
        request.fields["duedate"] = duedate;
        print(duedate);
      }
      if (projectpriority != null) {
        request.fields["projectpriority"] = projectpriority;
        print(projectpriority);
      }
      if (projectstatus != null) {
        request.fields["projectstatus"] = projectstatus;
        print(projectstatus);
      }
      if (inspectionpersonid != null) {
        request.fields["inspectionpersonid"] = inspectionpersonid;
        print(inspectionpersonid);
      }
      if (inspectionstatus != null) {
        request.fields["inspectionstatus"] = inspectionstatus;
        print(inspectionstatus);
      }

      if (assignedtopersonid != null) {
        request.fields["assignedtopersonid"] = assignedtopersonid;
        print(assignedtopersonid);
      }
      if (installationstatus != null) {
        request.fields["installationstatus"] = installationstatus;
        print(installationstatus);
      }
      if (measuredate != null) {
        request.fields['inspectiondates'] = '$measuredate'.toString();
        print(measuredate);
      }
      if (installdate != null) {
        request.fields['assigneddates'] = '$installdate'.toString();
        print(installdate);
      }

      if (projectCategory != null) {
        request.fields["projectCategory"] = projectCategory;
        print(projectCategory);
      }
      request.fields["layoutsCount"] =
          images == null ? "0" : images.length.toString();
      request.fields["ordersCount"] =
          images1 == null ? "0" : images1.length.toString();
      // if (images != null || images.length != 0) {
      //   for (var i in images) {
      //     request.files.add(
      //       http.MultipartFile.fromBytes(
      //         "layouts",
      //         i.readAsBytesSync(),
      //         filename: "test.${i.path.split(".").last}",
      //         contentType: MediaType("image", "${i.path.split(".").last}"),
      //       ),
      //     );
      //   }
      // }
      // if (images1 != null || images1.length != 0) {
      //   for (var i in images1) {
      //     request.files.add(
      //       http.MultipartFile.fromBytes(
      //         "orders",
      //         i.readAsBytesSync(),
      //         filename: "test.${i.path.split(".").last}",
      //         contentType: MediaType("image", "${i.path.split(".").last}"),
      //       ),
      //     );
      //   }
      // }
      request.send().then((onValue) async {
        pr.hide();
        if (onValue.statusCode == 200) {
          if ((newLayoutImages != null && newLayoutImages.length != 0) ||
              (newOrderImages != null && newOrderImages.length != 0)) {
            String responseData = await onValue.stream.bytesToString();
            final jsonData = jsonDecode(responseData);
            if (jsonData["status"] == "success") {
              String projectId = jsonData["projectId"];
              String uploadImagesResponse =
                  await startUploadingImages(projectId);
              if (uploadImagesResponse == "All Images Uploaded") {
                Navigator.pop(context, onbackpress);
                Fluttertoast.showToast(
                    msg: "Project Updated",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (uploadImagesResponse == "Some Images Uploaded") {
                Navigator.pop(context, onbackpress);
                Fluttertoast.showToast(
                    msg:
                        "Project updated, but some images aren't uploaded due to some issue.",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_LONG);
              } else if (uploadImagesResponse == "No Images Uploaded") {
                Navigator.pop(context, onbackpress);
                Fluttertoast.showToast(
                    msg:
                        "Project updated, but all images aren't uploaded due to some issue.",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_LONG);
              }
            } else {
              Navigator.pop(context, onbackpress);
              Fluttertoast.showToast(
                  msg:
                      "Project updated, but all images aren't uploaded due to some issue.",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_LONG);
            }
          } else {
            Navigator.pop(context, onbackpress);
            Fluttertoast.showToast(
                msg: "Project Updated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          showGenericError();
        }
      });
    } catch (error) {
      pr.hide();
      showGenericError();
      print(error);
    }
  }
}
