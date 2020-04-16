class Tag{
  String tagName;
  String comment;
  Coord startCoordinate;
  Coord endCoordinate;
  Tag(this.tagName, this.startCoordinate, this.endCoordinate, this.comment);
}

class Coord{
  double x;
  double y;
  Coord(this.x, this.y);
}

