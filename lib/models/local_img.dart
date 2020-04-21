import 'package:flutter/foundation.dart';
import './tag.dart';

class Photo {
  int id;
  int projectId;
  String title;
  List<Tag> tags;
  Photo({
    this.id,
    @required this.title,
    @required this.projectId,
    // this.tags,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "imageid": id,
      "projectId": projectId,
      "imagetitle": title,
      // "tags":tags,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    id = map['imageid'];
    projectId = map['projectId'];
    title = map['imagetitle'];
  }
}
