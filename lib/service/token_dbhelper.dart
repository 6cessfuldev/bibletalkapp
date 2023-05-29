import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/token.dart';

class TokenDBHelper {

  static Database? _database;
  static const String dbName = "token_database.db";
  static const String tableName = "tokens";

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $tableName(count INTEGER, updateDate TEXT)');
      },
    );

    return database;
  }

  Future<void> insertToken(Token token) async {
    final Database db = await database;
    await db.insert(
      'tokens',
      token.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<List<Token>> getTokens() async {
    final List<Map<String, dynamic>> maps = await getData();
    print(maps);
    if(maps.isEmpty) {
      Token token = Token(count: 5, updateDate: DateTime.now().toString());
      await insertToken(token);
      return [token];
    }else{
      return List.generate(maps.length, (i) {
        return Token(
          count: maps[i]['count'],
          updateDate: maps[i]['updateDate'],
        );
      });
    }
  }

  Future<void> updateToken (Token token) async {
    final db = await database;
    await db.update(
      'tokens',
      token.toMap(),
    );
  }

  static Future<int> refreshToken() async {
    List<Token> list =  await TokenDBHelper().getTokens();
    if(list.isNotEmpty) {
      int _token = list[0].count;
      DateTime update = DateTime.parse(list[0].updateDate);
      print(update);
      print(DateTime.now());
      print(update.difference(DateTime.now()).inDays.abs());
      if(update.difference(DateTime.now()).inDays.abs() > 0) {
        Token newToken = Token(count: 5, updateDate: DateTime.now().toString());
        TokenDBHelper().updateToken(newToken);
        return newToken.count;
      } else {
        return list[0].count;
      }
    } else{
      return 0;
    }
  }

  static Future costToken() async {
    List<Token> list =  await TokenDBHelper().getTokens();
    Token token = list[0];
    Token newToken = Token(count: token.count - 1, updateDate: DateTime.now().toString());
    await TokenDBHelper().updateToken(newToken);
  }

}