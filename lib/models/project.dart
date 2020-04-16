import 'package:screenshot_manager/models/local_img.dart';

class Project {
  int id;
  String title;
  List<Photo> photos;
  Project({this.id, this.title, this.photos});
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "title": title,
      // "photos": photos.map((photo) => photo.toMap()).toList(),
    };
    return map;
  }
  Project.fromMap(Map<String, dynamic> map){
    id = map['id'];
    title = map['title'];
    // photos = map['photos']
  }
}
