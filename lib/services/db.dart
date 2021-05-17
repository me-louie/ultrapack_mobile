import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ultrapack_mobile/models/Model.dart';

abstract class DB {
  static Future<Database>? database;

  static Future<void> init() async {
    if (database != null) {
      return;
    }

    try {
      database =
          openDatabase(join(await getDatabasesPath(), 'ultrapack_database.db'),
              onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE items_inventory (id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, weight INTEGER)');

        await db.execute('CREATE TABLE backpacks ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name STRING, '
            'description STRING, '
            'weight INTEGER)');
        await db.execute(
            'CREATE TABLE items_backpacks ( itemId INTEGER, backpackId INTEGER )');
      }, version: 1);
      Database db = (await database)!;
      print('db initialized!!!!!');
    } catch (ex) {
      print(ex);
    }
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    final Database _db = (await database)!;
    return _db.query(table);
  }

  static Future<int> insert(String table, Model model) async {
    final Database _db = (await database)!;
    return await _db.insert(table, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> update(String table, Model model) async {
    final Database _db = (await database)!;
    return _db
        .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  static Future<int> delete(String table, Model model) async {
    final Database _db = (await database)!;
    return await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
  }

  static Future<int> deleteById(String table, int id) async {
    final Database _db = (await database)!;
    return await _db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getBackpackItems(
      String table, Model backpack) async {
    final Database _db = (await database)!;
    List<Map<String, dynamic>> list = await _db.rawQuery(
        'SELECT items_inventory.name FROM items_inventory INNER JOIN items_backpacks ON items_inventory.id = items_backpacks.itemId WHERE items_backpacks.backpackId = 1');
    print(list);
    return list;
  }
}
