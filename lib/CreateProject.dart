import 'dart:convert';
import 'dart:io';
import 'package:aq_admin/HomeScreen.dart';
import 'package:aq_admin/stful_dialog.dart';
import 'package:intl/intl.dart';
import 'package:aq_admin/images/ImageGrid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'base_url.dart';

class ContactDetails extends StatefulWidget {
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  double totalImagesToUpload = 0.0;
  double currentImageNumber = 0.0;

  ProgressDialog pr;
  _getRequests() async {
    setState(() {
      images.length;
    });
  }

  DateTime pickedDate;
  TimeOfDay time;
  DateTime selectedDateTime;
  Future<void> cureentDateTime() {
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    selectedDateTime = DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, time.hour, time.minute);
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(selectedDateTime);
    addEmployee(formatted);
  }

  Future<void> getClientNamesForSuggestion(String initialLetter) async {
    suggestions.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    try {
      var response = await http.get(
        '${ApiBaseUrl.BASE_URL}/restapi/user/getclientnames/$initialLetter',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      );
      Map<String, dynamic> res = json.decode(response.body);
      print('res: $res');
      List<dynamic> temp = res['clientNames'];
      for (int i = 0; i < temp.length; i++) {
        suggestions.add(temp[i].toString());
      }
      print('suggestionList: $suggestions');
      autoFillData = res['clientDetails'];
      print('autoFillData: $autoFillData');
    } catch (e) {
      print('getClientNamesForSuggestion: $e');
    }
  }

  void showLoadingSpinner() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              Text('     Please wait'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      try {
        await cureentDateTime();
      } catch (e) {
        print('SomeError occured in initState: $e');
      }
    });
    // Future.wait([cureentDateTime(), getClientNamesForSuggestion()]);
  }

  var _selecteditem;
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
  bool _validate = false;

  int i = 0;

  List<Color> _colors = [Colors.grey[200], Colors.red, Color(0xff44aae4)];

  String text = 'incomplete';

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool validate = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _pname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _mobno = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _notes = TextEditingController();
  final _text = TextEditingController();
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  var myData;
  File _image, _image1;
  final picker = ImagePicker();
  final picker1 = ImagePicker();
  List<String> userList;
  List<File> images = [];
  List<File> images1 = [];
  bool _loadingPath = false;
  var _path;
  String assignedId;
  Map<String, String> _paths;
  File file;
  List<File> file1 = [];
  String _extension;

  List<String> suggestions = [];
  List<dynamic> autoFillData = [];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      images.add(_image);
      Navigator.pop(context);
      _displaySnackBar(context, 'Images added for Layout', images);
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
          print(images);
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
          var abc = i.value;
          file = new File(abc);
          images.add(file);
          print(images);
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

  _displaySnackBar(BuildContext context, String msg, List image) {
    int i = image.length;
    final snackBar = SnackBar(
      content: Text('$msg : $i'),
      action: SnackBarAction(
        label: 'View Image',
        onPressed: () {
          setState(() {
            Navigator.of(context)
                .push(
                  new MaterialPageRoute(
                    builder: (_) => ImageGrid(
                      imageList: images,
                      name: 'Layout Images',
                    ),
                  ),
                )
                .then((val) => val ? _getRequests() : null);
            // userlist.removeAt(i);
          });
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _displaySnackBar1(BuildContext context, String msg, List image) {
    int i = image.length;
    final snackBar = SnackBar(
      content: Text('$msg : $i'),
      action: SnackBarAction(
        label: 'View Image',
        onPressed: () {
          setState(() {
            print(images);
            Navigator.of(context)
                .push(
                  new MaterialPageRoute(
                    builder: (_) => ImageGrid(
                      imageList: images1,
                      name: 'Order Images',
                    ),
                  ),
                )
                .then((val) => val ? _getRequests() : null);
            // userlist.removeAt(i);
          });
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future getImage1() async {
    final pickedFile1 = await picker1.getImage(source: ImageSource.camera);
    print(pickedFile1);

    setState(() {
      _image1 = File(pickedFile1.path);
      images1.add(_image1);
      Navigator.pop(context);
      _displaySnackBar1(context, 'Images added for Orders', images1);
    });
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
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff649cb2),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Create Project'),
        backgroundColor: Color(0xff669cb2),
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
                      Text(
                        "Please Fill Project Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      // FormBuilderTextField(
                      //   attribute: "Name",
                      //   decoration: const InputDecoration(
                      //     icon: Icon(
                      //       Icons.assessment,
                      //       color: Color(0xff44aae4),
                      //     ),
                      //     // hintText: 'First Name',
                      //     labelText: 'Project Name',
                      //   ),
                      //   validators: [FormBuilderValidators.required()],
                      //   keyboardType: TextInputType.text,
                      //   controller: _pname,
                      //   maxLines: 1,
                      // ),
                      AutoCompleteTextField(
                        textCapitalization: TextCapitalization.none,
                        clearOnSubmit: false,
                        textChanged: (data) {
                          if (data.length == 1) {
                            Future.delayed(Duration.zero).then((_) async {
                              showLoadingSpinner();
                              try {
                                await getClientNamesForSuggestion('$data');
                                Navigator.of(context).pop();
                              } catch (e) {
                                print('getClientNamesForSuggestion error $e');
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        itemFilter: (suggestion, query) {
                          return suggestion
                              .toString()
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        },
                        itemSorter: (a, b) {
                          return a.toString().compareTo(b.toString());
                        },
                        itemSubmitted: (item) {
                          Map<dynamic, dynamic> temp;
                          for (int i = 0; i < autoFillData.length; i++) {
                            if (autoFillData[i]['firstname'] == item) {
                              temp = autoFillData[i];
                              print('Other details of Client: $temp');
                              break;
                            }
                          }
                          _name.text = item;
                          _mobno.text = temp['phone'];
                          _email.text = temp['email'];
                          // _address.text = temp['address'];
                        },
                        itemBuilder: (context, suggestion) {
                          return Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Text('$suggestion'),
                              ],
                            ),
                          );
                        },
                        suggestions: suggestions,
                        decoration: InputDecoration(
                          icon: Icon(
                            FontAwesomeIcons.userCircle,
                            color: Color(0xff669cb2),
                          ),
                          // hintText: 'First Name',
                          labelText: 'Enter Name',
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        ),
                        keyboardType: TextInputType.text,
                        controller: _name,
                        // maxLines: 1,
                      ),
                      TextField(
                        maxLength: 14,
                        decoration: InputDecoration(
                          counterText: "",
                          icon: Icon(
                            FontAwesomeIcons.phoneSquareAlt,
                            color: Color(0xff669cb2),
                          ),
                          labelText: 'Phone No',
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        controller: _mobno,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Color(0xff669cb2),
                          ),
                          hintText: 'Enter a email address',
                          labelText: 'Email',
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          errorText: validate ? 'Value Can\'t Be Empty' : null,
                          icon: Icon(
                            FontAwesomeIcons.city,
                            color: Color(0xff669cb2),
                          ),
                          hintText: 'Enter a Address',
                          labelText: 'Address',
                        ),
                        minLines: 1,
                        maxLines: 2,
                        controller: _address,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: <Widget>[],
                      // ),

                      // Container(
                      //   margin: EdgeInsets.only(right: 70),
                      //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //       border: Border.all()),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton(
                      //         hint: Text('Project Status'),
                      //         value: _selecteditem,
                      //         items: [
                      //               'Created ',
                      //               'Measured',
                      //               'Installed',
                      //               'Estimate Created',
                      //               'Paid',
                      //               '3rd Party Handover'
                      //             ]
                      //                 .map((hearabout) => DropdownMenuItem(
                      //                       value: hearabout,
                      //                       child: Text("$hearabout"),
                      //                     ))
                      //                 ?.toList() ??
                      //             [],
                      //         onChanged: (value) {
                      //           setState(() {
                      //             _selecteditem = value;
                      //           });
                      //         }),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 60),
                            child: Text(
                              'Measurement Date & Time *',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
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
                              margin: EdgeInsets.only(left: 30),
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Color(0xff669cb2))),
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
                                    formatdate == null
                                        ? 'Select Date'
                                        : '$formatdate',
                                    style: TextStyle(fontSize: 16),
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
                              margin: EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Color(0xff669cb2))),
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
                                    finalDate == null
                                        ? 'Time'
                                        : '${DateFormat.jm().format(selectedDateTime)}',
                                    // : '${time.hour}:${time.minute}',
                                    style: TextStyle(fontSize: 16),
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
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 60),
                            child: Text(
                              'Measurement Assigned To *',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      Container(
                        margin: EdgeInsets.only(right: 70),
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Color(0xff669cb2))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: Text('Project Assigned to'),
                              value: _selecteditem1,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                              icon: userData == null || userData.length == 0
                                  ? Icon(
                                      Icons.restore,
                                      size: 25,
                                    )
                                  : Icon(
                                      Icons.arrow_drop_down,
                                      size: 28,
                                    ),
                              items: userData?.map((item) {
                                    bool value = item['assigned'];
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Row(
                                        children: <Widget>[
                                          value
                                              ? Text(
                                                  '${item['name']}',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              : Text('${item['name']}',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  )),
                                        ],
                                      ),
                                    );
                                  })?.toList() ??
                                  [],
                              onChanged: (value) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  _selecteditem1 = value;
                                  assignedId = _selecteditem1["id"];
                                });
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 30, right: 10),

                        child: TextFormField(
                          // textInputAction: TextInputAction.send,
                          controller: _notes,
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 4,
                          decoration: InputDecoration(
                              labelText: 'Measurements Notes',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Measurements Notes'),
                        ),

                        // SizedBox(width: 10,),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // val1
                      //     ? Container(
                      //         margin: EdgeInsets.only(left: 35),

                      //         child: TextField(
                      //           // textInputAction: TextInputAction.send,
                      //           controller: _text,
                      //           keyboardType: TextInputType.multiline,
                      //           minLines: 2,
                      //           maxLines: 4,

                      //           decoration: InputDecoration(
                      //             errorText: _validate
                      //                 ? 'Please Fill Details then update the status'
                      //                 : null,
                      //             contentPadding:
                      //                 const EdgeInsets.symmetric(
                      //               vertical: 10.0,
                      //               horizontal: 20.0,
                      //             ),
                      //             border: OutlineInputBorder(
                      //                 borderRadius:
                      //                     BorderRadius.circular(10)),
                      //             hintText:
                      //                 'Need details of incompletion',
                      //           ),
                      //         ),

                      //         // SizedBox(width: 10,),
                      //       )
                      //     : SizedBox(),

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            height: 40.0,
                            child: RaisedButton.icon(
                                onPressed: () {
                                  check = false;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  this
                                      ._scaffoldKey
                                      .currentState
                                      .showBottomSheet(
                                          (ctx) => _buildBottomSheet(ctx));
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
                                      fontSize: 14, color: Colors.white),
                                )),
                          ),
                          Spacer(),
                          SizedBox(
                            height: 40.0,
                            child: RaisedButton.icon(
                                color: Color(0xff669cb2),
                                onPressed: () {
                                  check = true;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  this
                                      ._scaffoldKey
                                      .currentState
                                      .showBottomSheet(
                                          (ctx) => _buildBottomSheet(ctx));
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
                      Row(
                        children: <Widget>[
                          images.length != 0
                              ? FlatButton(
                                  onPressed: () {
                                    print(images);
                                    Navigator.of(context)
                                        .push(
                                          new MaterialPageRoute(
                                            builder: (_) => ImageGrid(
                                              imageList: images,
                                              name: 'Layout Images',
                                            ),
                                          ),
                                        )
                                        .then((val) =>
                                            val ? _getRequests() : null);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "View Images",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 2,
                                            color: Color(0xff669cb2),
                                            fontSize: 15),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 12, color: Color(0xff669cb2))
                                    ],
                                  ),
                                  // style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 18),
                                )
                              : SizedBox(
                                  height: 10,
                                ),
                          Spacer(),
                          images1.length != 0
                              ? FlatButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                          new MaterialPageRoute(
                                            builder: (_) => ImageGrid(
                                              imageList: images1,
                                              name: 'Orders Images',
                                            ),
                                          ),
                                        )
                                        .then((val) =>
                                            val ? _getRequests() : null);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "View Images",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 2,
                                            color: Color(0xff669cb2),
                                            fontSize: 15),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 12, color: Color(0xff669cb2))
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 10,
                                ),
                        ],
                      ),

                      new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 200,
                              margin: EdgeInsets.all(4),
                              child: new RaisedButton(
                                child: new Text("Submit"),
                                textColor: Colors.white,
                                color: Colors.blueGrey,
                                onPressed: () {
                                  if (_name.text.isEmpty) {
                                    _name.text = ' ';
                                  }
                                  if (_name.text.isNotEmpty) {
                                    setState(() {
                                      _name.text.isEmpty
                                          ? _validate = true
                                          : _validate = false;
                                      _address.text.isEmpty
                                          ? validate = true
                                          : validate = false;

                                      if (finalDate == null &&
                                          formatdate == null) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please select Date & Time slot",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        addData();
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      _name.text.isEmpty
                                          ? _validate = true
                                          : _validate = false;
                                      _address.text.isEmpty
                                          ? validate = true
                                          : validate = false;
                                    });
                                  }

                                  // print('vbvdj');
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              )),

                          // Expanded(
                          //   child: Container(
                          //       margin: EdgeInsets.all(4),
                          //       child: new RaisedButton(
                          //         child: paid ? Text("Paid") : Text("Unpaid"),
                          //         textColor: Colors.white,
                          //         color: paid ? Colors.green : Colors.grey,
                          //         onPressed: () {
                          //           // onTabChangeCallback();
                          //           if (paid == true) {
                          //             setState(() {
                          //               paid = false;
                          //             });
                          //           } else {
                          //             setState(() {
                          //               paid = true;
                          //             });
                          //           }
                          //         },
                          //         shape: new RoundedRectangleBorder(
                          //             borderRadius:
                          //                 new BorderRadius.circular(20.0)),
                          //       )),
                          //   flex: 1,
                          // ),
                        ],
                      ),

                      // SizedBox(
                      //   height: 40,
                      //   width: 150,
                      //   child: RaisedButton(
                      //     color: Color(0xff44aae4),
                      //     textColor: Colors.white,
                      //     elevation: 2,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20.0),
                      //     ),
                      //     child: Text("Submit"),
                      //     onPressed: () {
                      //       // print('vbvdj');
                      //       if (_fbKey.currentState.saveAndValidate()) {
                      //         print(_fbKey.currentState.value);
                      //         // Navigator.push(
                      //         //   context,
                      //         //   MaterialPageRoute(
                      //         //     builder: (context) => Measurements(
                      //         //       name: _name.text,
                      //         //       phoneno: _mobno.text,
                      //         //       email: _email.text,
                      //         //       address: _address.text,
                      //         //     ),
                      //         //   ),
                      //         // );
                      //       }
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      )
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
      //               size: 25,
      //               selectedColor: Color(0xff44aae4),
      //               unselectedColor: Color(0xff69737f),
      //               customColor: (index) => index == 0
      //                   ? Colors.yellow
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

  // _showImageDialog(File _img, String value) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => Dialog(
  //       elevation: 0,
  //       backgroundColor: Colors.transparent,
  //       child: Column(
  //         children: <Widget>[
  //           Expanded(
  //             child: Container(
  //               width: double.infinity,
  //               child: Image.file(
  //                 _img,
  //               ),
  //             ),
  //           ),
  //           Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
  //             IconButton(
  //               color: Colors.white,
  //               icon: Icon(Icons.close),
  //               onPressed: () => Navigator.pop(context),
  //             ),
  //             SizedBox(
  //               width: 10,
  //             ),
  //             IconButton(
  //                 color: Colors.white,
  //                 icon: Icon(Icons.delete),
  //                 onPressed: () {
  //                   setState(() {
  //                     if (value == "one") {
  //                       _image = null;
  //                       Navigator.pop(context);
  //                     } else {
  //                       _image1 = null;
  //                       Navigator.pop(context);
  //                     }
  //                   });
  //                 }),
  //           ])
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // List<String,dynamic> userData;

  String finalDate, formatdate;
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
        _selecteditem1 = null;
        userData.clear();

        FocusScope.of(context).requestFocus(new FocusNode());
        pickedDate = date;
        selectedDateTime = new DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, time.hour, time.minute);
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        formatdate = formatter.format(selectedDateTime);
        Fluttertoast.showToast(
            msg: "Please select Time slot",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        // print(formatted);
        // something like 2013-04-20
      });
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        _selecteditem1 = null;
        userData.clear();
        FocusScope.of(context).requestFocus(new FocusNode());
        time = t;
        selectedDateTime = new DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, time.hour, time.minute);
        finalDate = formatter.format(selectedDateTime);
        addEmployee(finalDate);
      });
  }

  List userData;
  Future<void> addEmployee(String date) async {
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
        print(response.body);
        Map<String, dynamic> loginData = json.decode(response.body);
        //  userData=loginData;
        if (mounted) {
          setState(() {
            userData = loginData['inspectors'];
            // print(userData);
            //  print(selectedDateTime);
            //  print(userData[i]['name']);
          });
        }
      } else {
        print(response.statusCode);
      }
    });
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
          builder: (ctx) => StatefulDialog(projectId, images, images1));

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  addData() async {
    print(' fbehbsifiuiu $selectedDateTime');
    if (assignedId == null) {
      Fluttertoast.showToast(
        msg: 'Please Assign Team',
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return;
    }
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    pr.show();
    // print(file.path);
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "${ApiBaseUrl.BASE_URL}/restapi/admin/create-project",
        ),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      request.headers["Content-Type"] = 'multipart/form-data';
      request.fields["projecttype"] = "Measurer";
      request.fields["firstname"] = _name.text;
      request.fields["inspectiondates"] = finalDate;
      request.fields["address"] = _address.text;
      request.fields["inspectionpersonid"] = assignedId;
      request.fields["phone"] = _mobno.text;
      request.fields["email"] = _email.text;
      request.fields["notes"] = _notes.text;
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
          if ((images != null && images.length != 0) ||
              (images1 != null && images1.length != 0)) {
            String responseData = await onValue.stream.bytesToString();
            final jsonData = jsonDecode(responseData);
            if (jsonData["status"] == "success") {
              String projectId = jsonData["projectId"];
              String uploadImagesResponse =
                  await startUploadingImages(projectId);
              if (uploadImagesResponse == "All Images Uploaded") {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
                Fluttertoast.showToast(
                    msg: "Project Created",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (uploadImagesResponse == "Some Images Uploaded") {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
                Fluttertoast.showToast(
                    msg:
                        "Project created, but some images aren't uploaded due to some issue.",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_LONG);
              } else if (uploadImagesResponse == "No Images Uploaded") {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
                Fluttertoast.showToast(
                    msg:
                        "Project created, but all images aren't uploaded due to some issue.",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_LONG);
              }
            } else {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
              Fluttertoast.showToast(
                  msg:
                      "Project created, but all images aren't uploaded due to some issue.",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_LONG);
            }
          } else {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
            Fluttertoast.showToast(
                msg: "Project Created",
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
        print(onValue.headers);
        print(onValue.contentLength);
      });
    } catch (e) {
      pr.hide();
      print(e);
      showGenericError();
    }

    // Response response;
    // Dio dio = new Dio();

    // FormData formData = new FormData.fromMap({
    //   "id": null,
    //   "projecttype": "Measurer",
    //   "firstname": "David",
    //   "lastname": "Smith",
    //   "address": "washington dc",
    //   "phone": "8668718426",
    //   "email": "ingaleswapnil56@gmail.com",
    //   "notes": "Nothing to note",
    // });
    // formData.files.addAll([
    //   MapEntry(
    //     "layouts",
    //     MultipartFile.fromFileSync(file.path, filename: "upload.png"),
    //   ),
    // ]);

    // String url = '${ApiBaseUrl.BASE_URL}/restapi/user/create-project';
    // try {
    //   response = await dio.post(url,
    //       data: formData,
    //       options: Options(headers: {
    //         "processData": false,
    //         "contentType": false,
    //         HttpHeaders.authorizationHeader: 'Bearer $token',
    //       }));
    //   print(response.statusCode);
    // } on DioError catch (e) {
    //   print(e.message);
    // } catch (e) {
    //   print(e.message);
    // }
  }
}
