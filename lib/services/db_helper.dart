import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot_manager/models/local_img.dart';
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
    var db = await openDatabase(path,
        version: 1, onCreate: _onCreate);
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
      'CREATE TABLE $IMAGE_TABLE ($IMAGE_ID INTEGER , $IMAGE_TITLE TEXT, $IMAGE_PROJECT_ID INTEGER)',
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

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
