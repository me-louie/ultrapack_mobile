import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ultrapack_mobile/models/Backpack.dart';
import 'package:ultrapack_mobile/models/ItemsBackpacks.dart';
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
        await db.execute('CREATE TABLE items_inventory ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name STRING, '
            'weight INTEGER)');

        await db.execute('CREATE TABLE backpacks ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name STRING, '
            'description STRING)');
        await db.execute('CREATE TABLE items_backpacks ('
            'itemId INTEGER, '
            'backpackId INTEGER, '
            'PRIMARY KEY(itemId, backpackId))');
      }, version: 1);
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

  static Future<int> deleteBackpackItem(int itemId, int backpackId) async {
    final Database _db = (await database)!;
    return await _db.delete('items_backpacks',
        where: 'itemId = ? AND backpackId = ?',
        whereArgs: [itemId, backpackId]);
  }

  static Future<int> emptyAndDeleteBackpack(int backpackId) async {
    final Database _db = (await database)!;
    await _db.delete(ItemsBackpacks.table,
        where: 'backpackId = ?', whereArgs: [backpackId]);
    return await deleteById(Backpack.table, backpackId);
  }

  static Future<List<Map<String, dynamic>>> getBackpackItems(int id) async {
    final Database _db = (await database)!;
    List<Map<String, dynamic>> list = await _db.rawQuery(
        'SELECT items_inventory.name, items_inventory.weight, items_inventory.id '
        'FROM items_inventory '
        'INNER JOIN items_backpacks '
        'ON items_inventory.id = items_backpacks.itemId '
        'WHERE items_backpacks.backpackId = $id');
    return list;
  }

  static Future<int> getBackpackWeight(int id) async {
    final Database _db = (await database)!;
    List<Map<String, dynamic>> result =
        await _db.rawQuery('SELECT COALESCE(SUM(weight), 0) as TotalWeight '
            'FROM items_inventory '
            'INNER JOIN items_backpacks '
            'ON items_inventory.id = items_backpacks.itemId '
            'WHERE items_backpacks.backpackId = $id');
    int value = result[0]["TotalWeight"];
    return value;
  }

  static Future<List<Map<String, dynamic>>> getAllBackpackWeights() async {
    final Database _db = (await database)!;
    List<Map<String, dynamic>> results = await _db.rawQuery(
        'SELECT items_backpacks.backpackId, COALESCE(SUM(weight), 0) as TotalWeight '
        'FROM items_inventory '
        'INNER JOIN items_backpacks '
        'ON items_inventory.id = items_backpacks.itemId '
        'GROUP BY items_backpacks.backpackId');
    return results;
  }
}
