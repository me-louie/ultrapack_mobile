import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/Category.dart';
import 'package:ultrapack_mobile/models/ItemsCategories.dart';
import 'db.dart';

abstract class CategoryService {
  static Future<List<Category>> fetchCategories() async {
    List<Map<String, dynamic>> result = await DB.query(Category.table);
    return _convertResultToList(result);
  }

  static Future<int> addCategory(String name, Color color) async {
    int colorAsInt = color.value;
    Category category = new Category(name: name, tagColor: colorAsInt);
    return await DB.insert(Category.table, category);
  }

  static Future<int> deleteCategory(int id) async {
    return await DB.deleteById(Category.table, id);
  }

  static Future<int> attachCategoryToItem(int itemId, int categoryId) async {
    ItemsCategories itemCat =
        new ItemsCategories(itemId: itemId, categoryId: categoryId);
    return await DB.insert(ItemsCategories.table, itemCat);
  }

  static Future<List<Category>> getItemCategories(int itemId) async {
    List<Map<String, dynamic>> result = await DB.getItemCategories(itemId);
    return _convertResultToList(result);
  }

  static Future<List<Object?>> updateItemCategories(
      int itemId, Set<Category> catsToAdd, Set<Category> catsToRemove) async {
    List<Object?> result =
        await DB.updateItemCategories(itemId, catsToAdd, catsToRemove);
    return result;
  }

  static List<Category> _convertResultToList(
      List<Map<String, dynamic>> dbResults) {
    return dbResults.map((cat) => Category.fromMap(cat)).toList();
  }
}
