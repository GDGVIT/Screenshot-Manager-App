import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot_manager/models/local_img.dart';
import 'package:screenshot_manager/models/tag.dart';
import '../models/project.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;

  static const String PROJECT_ID = 'id';
  static const String PROJECT_TITLE = 'title';
  static const String PROJECT_TABLE = 'projects';

  static const String IMAGE_TABLE = 'photos';
  static const String IMAGE_ID = 'imageid';
  static const String IMAGE_PROJECT_ID = 'projectId';
  static const String IMAGE_TITLE = 'imagetitle';

  static const String TAG_TABLE = 'tags';
  static const String TAG_ID = 'tagId';
  static const String TAG_IMAGE_ID = 'imageId';
  static const String TAG_NAME = 'tagName';
  static const String TAG_COMMENT = 'comment';
  static const String TAG_START_COORD = 'start_coord';
  static const String TAG_END_COORD = 'end_coord';

  static const String DB_NAME = 'projects.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path + DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // static Future _onConfigure(Database db) async {
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }

  _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $PROJECT_TABLE ($PROJECT_ID INTEGER PRIMARY KEY AUTOINCREMENT, $PROJECT_TITLE TEXT)',
    );
    await db.execute(
      'CREATE TABLE $IMAGE_TABLE ($IMAGE_ID INTEGER PRIMARY KEY AUTOINCREMENT, $IMAGE_TITLE TEXT, $IMAGE_PROJECT_ID INTEGER)',
    );
    await db.execute(
      'CREATE TABLE $TAG_TABLE ($TAG_ID INTEGER PRIMARY KEY AUTOINCREMENT,$TAG_IMAGE_ID INTEGER, $TAG_NAME TEXT ,$TAG_COMMENT TEXT, $TAG_START_COORD TEXT, $TAG_END_COORD TEXT)',
    );
  }

  Future<Project> saveProject(Project project) async {
    var dbClient = await db;
    project.id = await dbClient.insert(PROJECT_TABLE, project.toMap());
    return project;
  }

  Future<Photo> savePhoto(Photo photo) async {
    var dbClient = await db;
    photo.id = await dbClient.insert(
      IMAGE_TABLE,
      photo.toMap(),
    );
    return photo;
  }

  Future<Tag> saveTag(Tag tag) async {
    var dbClient = await db;
    tag.tagId = await dbClient.insert(TAG_TABLE, tag.toMap());
    return tag;
  }

  Future<List<Project>> getProjects() async {
    var dbClient = await db;
    List<Map<String, dynamic>> projectMaps = await dbClient
        .query(PROJECT_TABLE, columns: [PROJECT_ID, PROJECT_TITLE]);
    List<Project> projects = projectMaps
        .map(
          (project) => Project.fromMap(project),
        )
        .toList();
    return projects;
  }

  Future<List<Photo>> getPhotos(int projectId) async {
    var dbClient = await db;
    List<Map<String, dynamic>> photoMaps = await dbClient.query(IMAGE_TABLE,
        columns: [IMAGE_ID, IMAGE_TITLE],
        where: '$IMAGE_PROJECT_ID == $projectId');
    List<Photo> photos = photoMaps.map((photoMap) {
      return Photo.fromMap(photoMap);
    }).toList();
    return photos;
  }

  Future<List<Tag>> getTags(int photoId) async {
    var dbClient = await db;
    List<Map> tagMaps = await dbClient.query(
      TAG_TABLE,
      columns: [
        TAG_ID,
        TAG_NAME,
        TAG_IMAGE_ID,
        TAG_START_COORD,
        TAG_END_COORD,
        TAG_COMMENT,
      ],
      where: '$TAG_IMAGE_ID == $photoId',
    );

    List<Tag> tags = tagMaps.map((tag) {
      return Tag.fromMap(tag);
    }).toList();

    return tags;
  }

  Future<int> updateTagComment(int tagId, String comment) async {
    var dbClient = await db;
    int i = await dbClient.update(
      TAG_TABLE,
      {TAG_COMMENT: comment},
      where: '$TAG_ID == $tagId',
    );
    print('comment updated: $i');
    return i;
  }

  Future<int> deleteProject(int id) async {
    var dbClient = await db;
    int deletedPhotos =
        await dbClient.delete(IMAGE_TABLE, where: '$IMAGE_PROJECT_ID == $id ');
    int deletedProject =
        await dbClient.delete(PROJECT_TABLE, where: '$PROJECT_ID == $id');
    print("project with id = $id removed, $deletedPhotos photos");
    return deletedProject;
  }

  Future<int> deletePhoto(int photoID) async{
    var dbClient = await db;
    int photoDeleted = await dbClient.delete(IMAGE_TABLE, where: '$IMAGE_ID == $photoID');
    print('image with id $photoID deleted, function returned $photoDeleted');
    return photoDeleted;
  }



  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
