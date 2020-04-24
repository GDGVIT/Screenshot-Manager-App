import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot_manager/models/local_img.dart';
import 'package:screenshot_manager/models/tag.dart';
import 'package:screenshot_manager/services/db_helper.dart';
import 'package:screenshot_manager/utils.dart';

class PhotoDetailScreen extends StatefulWidget {
  final Photo photo;
  PhotoDetailScreen(this.photo);
  @override
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  List<Tag> tagList;
  DBHelper dbHelper;
  @override
  void initState() {
    dbHelper = DBHelper();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text('Add/Edit Comment for $name ${number+1}'),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            child: TextFormField(
              initialValue: comment,
              onChanged: (value) {
                _onSaved(tagId, value);
              },
              maxLines: 4,
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
    return Scaffold(
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
                                  '${i + 1} ' + tagList[i].tagName,
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
                              onLongPress: (){
                                print("hi");
                                Fluttertoast.showToast(msg: '${tagList[i].tagName} ${i+1}');
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
                                      backgroundColor: primaryColor.withOpacity(0.5),
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
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
    );
  }
}
