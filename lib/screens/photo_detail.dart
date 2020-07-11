import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import '../models/local_img.dart';
import '../models/tag.dart';
import '../services/db_helper.dart';
import '../utils.dart';
import 'dart:ui' as ui;

import '../utils.dart';

class PhotoDetailScreen extends StatefulWidget {
  final Photo photo;
  PhotoDetailScreen(this.photo);
  @override
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  static GlobalKey previewContainer = GlobalKey();
  List<Tag> tagList;
  DBHelper dbHelper;
  @override
  void initState() {
    dbHelper = DBHelper();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _takeScreenShot() async {
    try {
      RenderRepaintBoundary boundary =
          previewContainer.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      final directory = (await getExternalStorageDirectory()).path;
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      // print(pngBytes);
      print("$directory");
      // File imgFile = new File('$directory/screenshot.png');
      // imgFile.writeAsBytes(pngBytes);
      String str = "";
      for (int i = 0; i < tagList.length; i++) {
        str += '*${tagList[i].tagName} - ${i + 1}*\n${tagList[i].comment}\n\n';
      }
      Share.file(
        "Screenshot comments",
        'screenshot.png',
        pngBytes,
        'image/png',
        text: str,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  _onSaved(int tagId, String comment) {
    // print('$tagId: $comment');
    dbHelper.updateTagComment(tagId, comment);
  }

  showTextBox(int tagId, String comment, String name, int number) {
    print('tag id is $tagId');

    showDialog(
      context: context,
      // barrierDismissible: false,
      child: AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text(
              'DISMISS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text('Add/Edit Comment for $name ${number + 1}'),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            child: TextFormField(
              initialValue: comment,
              onChanged: (value) {
                _onSaved(tagId, value);
              },
              minLines: 1,
              maxLines: 7,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                alignLabelWithHint: true,
                fillColor: Colors.grey[200],
                hintText: 'Comment',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: previewContainer,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.share),
          onPressed: _takeScreenShot,
        ),
        appBar: AppBar(
          title: Text('Add/Edit Annotation'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.deletePhoto(widget.photo.id).then((value) {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(msg: 'Photo removed');
                });
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: dbHelper.getTags(widget.photo.id),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            tagList = snapshot.data;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.07),
                      child: Wrap(
                        children: <Widget>[
                          for (int i = 0; i < tagList.length; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  showTextBox(
                                    tagList[i].tagId,
                                    tagList[i].comment,
                                    tagList[i].tagName,
                                    i,
                                  );
                                },
                                child: Chip(
                                  backgroundColor: primaryColor,
                                  label: Text(
                                    tagList[i].tagName + ' - ${i + 1}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Utility.imageFromBase64String(
                              widget.photo.title,
                            ),
                          ),
                          for (int i = 0; i < tagList.length; i++)
                            Positioned(
                              top: double.parse(
                                      '${tagList[i].startCoordinate.y}') *
                                  0.75,
                              child: GestureDetector(
                                onLongPress: () {
                                  print("hi");
                                  Fluttertoast.showToast(
                                      msg: '${tagList[i].tagName} ${i + 1}');
                                },
                                onTap: () {
                                  showTextBox(
                                    tagList[i].tagId,
                                    tagList[i].comment,
                                    tagList[i].tagName,
                                    i,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.zero,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            primaryColor.withOpacity(0.5),
                                        child: Text(
                                          '${i + 1}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  width: (double.parse(
                                              '${tagList[i].endCoordinate.x}') -
                                          double.parse(
                                              '${tagList[i].startCoordinate.x}')) *
                                      0.75,
                                  height: (double.parse(
                                              '${tagList[i].endCoordinate.y}') -
                                          double.parse(
                                              '${tagList[i].startCoordinate.y}')) *
                                      0.75,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
