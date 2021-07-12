import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_url.dart';

class Invoice extends StatefulWidget {
  final String invoiceUrl;
  final String id;
  Invoice({@required this.invoiceUrl, @required this.id});
  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  String localPath;
  String estimateId;
  String token;
  bool onbackpress = false;
  static final Random random = Random();
  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  onback() {
    Navigator.pop(context, onbackpress);
  }

  Future<bool> getPackageInfo() async {
    return onback();
  }

  ProgressDialog pr;
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
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back), onPressed: () => onback()),
          title: Text(
            "Invoice",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xff669cb2),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        title: Text('Delete Invoice !'),
                        content: Text(
                            'Are you sure you want to Delete this Invoice ?'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              // Navigator.pop(context, false);
                              Navigator.of(
                                context,
                                // rootNavigator: true,
                              ).pop(false);
                            },
                            child: Text('No',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          FlatButton(
                            onPressed: () {
                              // Navigator.pop(context, true);
                              setState(() {
                                deleteInvoice(widget.id);
                                Navigator.of(
                                  context,
                                  // rootNavigator: true,
                                ).pop(true);
                              });
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),

            //: new Container()
          ],
        ),
        body: localPath != null
            ? PDFView(
                filePath: localPath,
              )
            : Center(child: CircularProgressIndicator()),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     print(localPath);
        //     File testFile = new File(localPath);
        //     if (!await testFile.exists()) {
        //       await testFile.create(recursive: true);
        //       testFile.writeAsStringSync("share");
        //     }
        //     ShareExtend.share(testFile.path, "file");
        //   },
        //   child: Icon(Icons.share),
        //   backgroundColor: Colors.red,
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print(localPath);
            File testFile = new File(localPath);
            if (!await testFile.exists()) {
              await testFile.create(recursive: true);
              testFile.writeAsStringSync("share");
            }
            ShareExtend.share(testFile.path, "file");
          },
          child: Icon(Icons.share),
          backgroundColor: Color(0xff669cb2),
        ),
      ),
    );
  }

  Future loadPDF() async {
    String invoiceurl = widget.invoiceUrl;
    String url = "$invoiceurl";
    var response = await http.get(
      url,
    );
    var dir = await getApplicationDocumentsDirectory();
    var randid = random.nextInt(10000);
    File file = new File("${dir.path}/Magzine$randid.pdf");
    print(dir.path);
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    setState(() {
      localPath = file.path;
    });
  }

  deleteInvoice(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print(id);
    pr.show();
    String url = '${ApiBaseUrl.BASE_URL}/restapi/admin/deleteinvoice/$id';
    try {
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
          setState(() {
            print(response.statusCode);
            pr.hide();

            Navigator.pop(context, true);

            Fluttertoast.showToast(
                msg: "Invoice Deleted",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            //  print(userData[i]['name']);
          });
        } else {
          print(response.statusCode);
          pr.hide();
          Fluttertoast.showToast(
              msg: "Something went wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          throw Exception('dfdfdf');
        }
      });
    } catch (e) {
      print('delete invoice $e');
    }
  }
}
