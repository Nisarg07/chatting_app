import 'dart:io';

import 'package:chatting_app/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();
  Database _database;
  Future<Database> get dataBase async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + "TestDB.db";
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Users("
          "id INTEGER PRIMARY KEY,"
          "full_name TEXT,"
          "profile_pic TEXT"
          ")");
    });
  }

  newUsers(Users users) async {
    final db = await dataBase;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Users");
    int id = table.first['id'];
    var raw = await db.rawInsert(
        "INSERT Into Users (id,full_name,profile_pic)"
        "VALUES (?,?,?)",
        [id, users.full_name, users.profile_pic]);
    return raw;
  }
}
