import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'base_url.dart';

class StatefulDialog extends StatefulWidget {
  final String projectID;
  final List<File> layoutImages;
  final List<File> orderImages;
  StatefulDialog(this.projectID, this.layoutImages, this.orderImages);
  @override
  _StatefulDialogState createState() => _StatefulDialogState();
}

class _StatefulDialogState extends State<StatefulDialog> {
  double currentImageNumber = 0;
  double currentPercentage = 0;
  double totalImagesToUpload = 0;
  int numberOfImagesFailedToUpload = 0;

  @override
  void initState() {
    totalImagesToUpload = double.tryParse(
        (widget.layoutImages.length + widget.orderImages.length).toString());
    if (totalImagesToUpload != null) {
      setState(() {
        currentPercentage = currentImageNumber / totalImagesToUpload;
      });
    }
    print("totalImagesToUpload: $totalImagesToUpload");
    Future.delayed(Duration.zero).then((_) async => await startUploading());
    super.initState();
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/test$currentImageNumber.jpg';
    return filePath;
  }

  Future<File> compressImage(File file) async {
    String targetPath = await getFilePath();
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 50);

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Future<void> startUploading() async {
    if (widget.layoutImages != null) {
      for (var i in widget.layoutImages) {
        try {
          File temp = await compressImage(i);
          await uploadLayoutImages(temp);
        } catch (e) {
          await uploadLayoutImages(i);
        }
      }
    }
    if (widget.orderImages != null) {
      for (var i in widget.orderImages) {
        try {
          File temp = await compressImage(i);
          await uploadOrderImages(temp);
        } catch (e) {
          await uploadOrderImages(i);
        }
      }
    }
    if (numberOfImagesFailedToUpload == 0) {
      Navigator.of(context).pop("All Images Uploaded");
    } else if (numberOfImagesFailedToUpload > 0 &&
        numberOfImagesFailedToUpload < totalImagesToUpload) {
      Navigator.of(context).pop("Some Images Uploaded");
    } else if (numberOfImagesFailedToUpload == totalImagesToUpload) {
      Navigator.of(context).pop("No Images Uploaded");
    }
  }

  Future<void> uploadLayoutImages(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${ApiBaseUrl.BASE_URL}/restapi/user/projectimages"),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      request.headers["Content-Type"] = 'multipart/form-data';
      request.fields["projectId"] = widget.projectID;
      request.files.add(
        http.MultipartFile.fromBytes(
          "layouts",
          image.readAsBytesSync(),
          filename: "test.${image.path.split(".").last}",
          contentType: MediaType("image", "${image.path.split(".").last}"),
        ),
      );
      var response = await request.send();
      print("statusCode: ${response.statusCode}");
      if (response.statusCode != 200) {
        setState(() {
          numberOfImagesFailedToUpload += 1;
        });
      }
      currentImageNumber += 1;
      setState(() {
        currentPercentage = currentImageNumber / totalImagesToUpload;
      });
    } catch (e) {
      currentImageNumber += 1;
      setState(() {
        currentPercentage = currentImageNumber / totalImagesToUpload;
      });
      print(e);
    }
  }

  Future<void> uploadOrderImages(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${ApiBaseUrl.BASE_URL}/restapi/user/projectimages"),
      );
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      request.headers["Content-Type"] = 'multipart/form-data';
      request.fields["projectId"] = widget.projectID;
      request.files.add(
        http.MultipartFile.fromBytes(
          "orders",
          image.readAsBytesSync(),
          filename: "test.${image.path.split(".").last}",
          contentType: MediaType("image", "${image.path.split(".").last}"),
        ),
      );
      var response = await request.send();
      print("statusCode: ${response.statusCode}");
      if (response.statusCode != 200) {
        setState(() {
          numberOfImagesFailedToUpload += 1;
        });
      }
      currentImageNumber += 1;
      setState(() {
        currentPercentage = currentImageNumber / totalImagesToUpload;
      });
    } catch (e) {
      currentImageNumber += 1;
      setState(() {
        currentPercentage = currentImageNumber / totalImagesToUpload;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [Text("Uploading Images")],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                lineHeight: 15.0,
                percent: currentPercentage < 0.0
                    ? 0
                    : currentPercentage > 1.0
                        ? 1.0
                        : currentPercentage,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.green,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Uploading: ${currentImageNumber.round()} / ${totalImagesToUpload.round()}"),
            ),
            if (numberOfImagesFailedToUpload != 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Failed: $numberOfImagesFailedToUpload / ${totalImagesToUpload.round()}"),
              ),
          ],
        ),
      ),
    );
  }
}
