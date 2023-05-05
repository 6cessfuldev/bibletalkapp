import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/bookmark.dart';

class BookmarkDBHelper {
  static Database? _database;
  static const String dbName = "bookmark_database.db";
  static const String tableName = "bookmarks";

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, response TEXT, regDate TEXT)');
      },
    );
  }
  
  //db 초기화
  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    await deleteDatabase(path);
    _database = null;
  }

  //북마크 테이블 초기화
  Future<void> deleteTable() async {
    final db = await database;
    await db.execute('DROP TABLE $tableName');
  }

  //북마크 테이블 리셋
  Future<void> clearTableContents() async {
    final Database db = await database;
    await db.rawDelete('DELETE FROM $tableName');
  }

  Future<void> insertBookmark(Bookmark bookmark) async {
    final Database db = await database;
    await db.insert(
      'bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<List<Bookmark>> getBookmarks() async {
    final List<Map<String, dynamic>> maps = await getData();
    return List.generate(maps.length, (i) {
      return Bookmark(
        id: maps[i]['id'],
        title: maps[i]['title'],
        response: maps[i]['response'],
        regDate: maps[i]['regDate'],
      );
    });
  }

  void deleteBookmark(int? id) {
    database.then((db) {
      db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    });
  }

}
