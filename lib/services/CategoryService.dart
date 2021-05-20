import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/Category.dart';
import 'db.dart';

abstract class CategoryService {
  static Future<List<Category>> fetchCategories() async {
    List<Map<String, dynamic>> _results = await DB.query(Category.table);
    List<Category> categories =
        _results.map((cat) => Category.fromMap(cat)).toList();
    return categories;
  }

  static Future<int> addCategory(String name, Color color) async {
    int colorAsInt = color.value;
    Category category = new Category(name: name, tagColor: colorAsInt);
    return await DB.insert(Category.table, category);
  }

  static Future<int> deleteCategory(int id) async {
    return await DB.deleteById(Category.table, id);
  }
}
