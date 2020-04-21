import 'package:flutter/material.dart';
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

  showTextBox(int tagId, String comment, String name) {
    print('tag id is $tagId');

    showDialog(
      context: context,
      // barrierDismissible: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text('Add/Edit Comment for $name'),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: double.infinity,
            child: TextFormField(
              initialValue: comment,
              onChanged: (value) {
                // editedComment = value;
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
        // actions: <Widget>[
        //   FlatButton(
        //     child: Text('Submit'),
        //     textColor: primaryColor,
        //     onPressed: ()=> _onSaved(tagId, editedComment),
        //   ),
        //   FlatButton(
        //     child: Text('Cancel'),
        //     textColor: primaryColor,
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        // ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Annotation'),
        centerTitle: true,
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
                  Stack(
                    children: <Widget>[
                      Utility.imageFromBase64String(widget.photo.title),
                      for (int i = 0; i < tagList.length; i++)
                        Positioned(
                          top: double.parse('${tagList[i].startCoordinate.y}'),
                          child: GestureDetector(
                            onTap: () {
                              showTextBox(
                                tagList[i].tagId,
                                tagList[i].comment,
                                tagList[i].tagName,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                ),
                              ),
                              width: double.parse(
                                      '${tagList[i].endCoordinate.x}') -
                                  double.parse(
                                      '${tagList[i].startCoordinate.x}'),
                              height: double.parse(
                                      '${tagList[i].endCoordinate.y}') -
                                  double.parse(
                                      '${tagList[i].startCoordinate.y}'),
                            ),
                          ),
                        ),
                    ],
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
