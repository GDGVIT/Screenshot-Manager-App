import 'dart:io';

import 'package:flutter/material.dart';
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
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) async {
      String imgString = Utility.base64String(file.readAsBytesSync());
      Photo photo = Photo(
        title: imgString,
        projectId: widget.project.id,
      );
      photo = await dbHelper.savePhoto(photo);
      print(
          "photo saved with id = ${photo.id} and project id = ${photo.projectId}");
      refreshPhotos();
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
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10),
              itemCount: myPhotos.length,
              itemBuilder: (ctx, index) {
                return Utility.imageFromBase64String(myPhotos[index].title);
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
        },
      ),
    );
  }
}
