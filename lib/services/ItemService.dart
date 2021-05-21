import 'package:ultrapack_mobile/models/Item.dart';
import 'package:ultrapack_mobile/models/Model.dart';
import 'db.dart';

abstract class ItemService {
  static Future<List<Item>> fetchInventoryItems() async {
    List<Map<String, dynamic>> result = await DB.query(Item.table);
    return _convertResultToList(result);
  }

  static List<Item> _convertResultToList(List<Map<String, dynamic>> dbResults) {
    return dbResults.map((item) => Item.fromMap(item)).toList();
  }

  static Future<int> updateItem(Model item) async {
    return await DB.update(Item.table, item);
  }

  static Future<List<Object?>> bulkDelete(Set<int> itemsToRemove) async {
    return await DB.bulkDeleteById(Item.table, itemsToRemove);
  }

  static Future<int> delete(Model item) async {
    return await DB.delete(Item.table, item);
  }

  static Future<int> insert(Model item) async {
    return await DB.insert(Item.table, item);
  }
}
