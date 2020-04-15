import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './models/local_img.dart';
import './services/db_helper.dart';
import 'package:screenshot_manager/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screenshot Manager',
      theme: ThemeData(
        primaryColor: Color(0xFF34495E),
        accentColor: Color(0xFF798EA5),
      ),
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  Future<File> imageFile;
  Image image;
  DBHelper dbHelper;
  List<Photo> photos;

  @override
  void initState() {
    super.initState();
    photos = [];
    dbHelper = DBHelper();
  }

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      String imgString = Utility.base64String(file.readAsBytesSync());
      Photo photo = Photo(id: 0, title: imgString);
      dbHelper.save(photo);
      refreshPhotos();
    });
  }

  refreshPhotos() {
    dbHelper.getPhotos().then((imgArray) {
      setState(() {
        photos.clear();
        photos.addAll(imgArray);
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
        children: photos.map((photo) {
          return Utility.imageFromBase64String(photo.title);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: pickImageFromGallery,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: photoView(),
          ),
        ],
      ),
    );
  }
}

// class MyHomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.07,
//                 vertical: 10),
//             child: Column(
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'My Projects',
//                     style: headingTextStyle,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 MyProjectWidget(),
//                 MyProjectWidget(),
//                 MyProjectWidget(),
//                 MyProjectWidget(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyProjectWidget extends StatelessWidget {
  const MyProjectWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 5,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                height: 100,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('Comments'),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                height: 100,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
