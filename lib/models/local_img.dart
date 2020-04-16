import 'package:flutter/foundation.dart';
import './tag.dart';

class Photo {
  int id;
  int projectId;
  String title;
  // List<Tag> tags;
  Photo({
    @required this.id,
    @required this.title,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "projectId":projectId,
      "title": title,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map){
    id = map['id'];
    projectId = map['projectId'];
    title = map['title'];
  }
}
