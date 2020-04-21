import 'package:flutter/material.dart';
import 'package:screenshot_manager/models/local_img.dart';

class PhotoDetailScreen extends StatefulWidget {
  final Photo photo;
  PhotoDetailScreen(this.photo);
  @override
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('something'),
      ),
    );
  }
}
