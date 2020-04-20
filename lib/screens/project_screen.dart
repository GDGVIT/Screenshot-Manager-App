import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot_manager/models/local_img.dart';
import 'package:screenshot_manager/models/project.dart';
import 'package:screenshot_manager/services/db_helper.dart';

import '../utils.dart';

class ProjectScreen extends StatefulWidget {
  final Project project;
  ProjectScreen(this.project);

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<Photo> myPhotos;
  Future<File> imageFile;
  Image image;
  DBHelper dbHelper;
  @override
  void initState() {
    dbHelper = DBHelper();
    myPhotos = [];
    super.initState();
  }


  pickImageFromGallery() {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight:deviceHeight *0.7, maxWidth: deviceWidth * 0.7 ).then((file) async {
      try {
        String filename = file.path.split("/").last;
        FormData formData = FormData.fromMap(
          {
            'file': await MultipartFile.fromFile(
              file.path,
              filename: filename,
            ),
          },
        );
        Response response = await Dio().post(
          imagePostUrl,
          data: formData,
          onReceiveProgress: (recv, total) {
            print("recvd: $recv/$total");
          },
          onSendProgress: (sent, total) {
            print("sent: $sent/$total");
            
          },
          // options: Options(validateStatus: (statusCode) {
          //   if(statusCode !=200){
          //     Fluttertoast.showToast(msg: "Some error has occured");
          //     return false;
          //   }
          //   return true;
          // }),
        );

        print(response.statusCode);
        print(response.data);
        if (response.statusCode == 200) {
          String imgString = Utility.base64String(file.readAsBytesSync());
          Photo photo = Photo(
            title: imgString,
            projectId: widget.project.id,
          );
          photo = await dbHelper.savePhoto(photo);
          print(
              "photo saved with id = ${photo.id} and project id = ${photo.projectId}");
          refreshPhotos();
        } else {
          Fluttertoast.showToast(msg: "Some error occured");
        }
      } on DioError catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: "Some error occured");
      }
    });
  }

  refreshPhotos() {
    dbHelper.getPhotos(widget.project.id).then((imgArray) {
      setState(() {
        myPhotos.clear();
        myPhotos.addAll(imgArray);
      });
    });
  }

  photoView() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        mainAxisSpacing: 5,
        crossAxisSpacing: 2,
        children: myPhotos.map((photo) {
          return Utility.imageFromBase64String(photo.title);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor.withOpacity(0.9),
        child: Icon(Icons.file_upload),
        tooltip: 'Upload screenshot',
        onPressed: pickImageFromGallery,
      ),
      appBar: AppBar(
        title: Text(widget.project.title),
      ),
      body: FutureBuilder(
        future: dbHelper.getPhotos(widget.project.id),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          myPhotos = snapshot.data;
          myPhotos.sort((b, a) => a.id.compareTo(b.id));
          if (myPhotos.length == 0) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(60.0),
                child: Text(
                  'No images found\nPress upload button to start adding images',
                  style: TextStyle(color: accentColor),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 15),
                itemCount: myPhotos.length,
                itemBuilder: (ctx, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Utility.imageFromBase64String(myPhotos[index].title),
                  );
                },
                // crossAxisCount: 2,
                // childAspectRatio: 0.5,
                // mainAxisSpacing: 5,
                // crossAxisSpacing: 2,
                // children: myPhotos.map((photo) {
                //   return Utility.imageFromBase64String(photo.title);
                // }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
