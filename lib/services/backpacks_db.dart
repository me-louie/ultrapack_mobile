import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ultrapack_mobile/models/Model.dart';

abstract class BackpacksDB {
  static Database? _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'backpacks';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
      // _db!.execute('DELETE FROM backpacks');
      print('BACKPACKS db initialized!!!!!');
      print(_path);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE backpacks ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'name STRING, '
        'description STRING, '
        'weight INTEGER)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  static Future<int> insert(String table, Model model) async {
    return await _db!.insert(table, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
