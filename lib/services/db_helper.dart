import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot_manager/models/local_img.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String TABLE = 'LocalPhotos';
  static const String DB_NAME = 'photos.db';

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

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $TABLE ($ID INTEGER, $TITLE TEXT)');
  }

  Future<Photo> save(Photo photo) async {
    var dbClient = await db;
    photo.id = await dbClient.insert(TABLE, photo.toMap());
    return photo;
  }

  Future<List<Photo>> getPhotos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> photoMaps =
        await dbClient.query(TABLE, columns: [ID, TITLE]);
    List<Photo> photos = photoMaps.map((photoMap) {
      return Photo.fromMap(photoMap);
    }).toList();
    return photos;
  }

  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }
}
