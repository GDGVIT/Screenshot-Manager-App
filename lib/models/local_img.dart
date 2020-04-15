import 'package:flutter/foundation.dart';

class Photo {
  int id;
  String title;
  Photo({
    @required this.id,
    @required this.title,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "title": title,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map){
    id = map['id'];
    title = map['title'];
  }
}
