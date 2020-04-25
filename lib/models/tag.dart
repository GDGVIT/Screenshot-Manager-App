class Tag {
  int tagId;
  String tagName;
  String comment;
  int photoId;
  int projectId;
  Coord startCoordinate;
  Coord endCoordinate;
  Tag({
    this.tagId,
    this.projectId,
    this.photoId,
    this.tagName,
    this.startCoordinate,
    this.endCoordinate,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'tagId': tagId,
      'imageId': photoId,
      'tagName': tagName,
      'tag_projectId':projectId,
      'start_coord': startCoordinate.toString(),
      'end_coord': endCoordinate.toString(),
      'comment': comment,
    };
    return map;
  }

  Tag.fromMap(Map map) {
    tagId = map['tagId'];
    projectId = map['tag_projectId'];
    photoId = map['imageId'];
    tagName = map['tagName'];
    startCoordinate = Coord.fromString(map['start_coord']);
    endCoordinate = Coord.fromString(map['end_coord']);
    comment = map['comment'];
  }
}

class Coord {
  int x;
  int y;
  Coord(this.x, this.y);

  @override
  String toString() {
    String coord = "$x,$y";
    return coord;
  }

  Coord.fromString(String data){
    final coordinates = data.split(",");
    x = int.parse(coordinates.removeAt(0));
    y = int.parse(coordinates.removeAt(coordinates.length-1));
  }
}
