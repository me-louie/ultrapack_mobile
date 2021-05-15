import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ultrapack_mobile/models/Model.dart';

abstract class db {
  static Database ? _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    
    try {
      String _path = await getDatabasesPath() + 'items_inventory';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
      // _db!.execute('DELETE FROM items_inventory');
      print('db initialized!!!!!');
      print(_path);
    }
    catch (ex) {
      print(ex);
    }
  }
  static void onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE items_inventory (id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, weight INTEGER)'
    );
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  static Future<int> insert(String table, Model model) async {
    return await _db!.insert(table, model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> update(String table, Model model) async {
    return _db!.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  static Future<int> delete(String table, Model model) async {
    return await _db!.delete(table, where: 'id = ?', whereArgs: [model.id]);
  }
  static Future<int> deleteById(String table, int id) async {
    return await _db!.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
