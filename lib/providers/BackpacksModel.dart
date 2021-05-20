import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/Backpack.dart';
import 'package:ultrapack_mobile/models/Model.dart';
import 'package:ultrapack_mobile/services/db.dart';

class BackpacksModel extends ChangeNotifier {
  List<Backpack> backpacks = [];

  void loadData() async {
    List<Map<String, dynamic>> list = await DB.query(Backpack.table);
    backpacks = list.map((bp) => Backpack.fromMap(bp)).toList();
    notifyListeners();
  }

  List<Backpack> get getBackpacks {
    return backpacks;
  }

  int get length {
    return backpacks.length;
  }

  Future<int> delete(int backpackId) async {
    int deleted = await DB.deleteById(Backpack.table, backpackId);
    loadData();
    return deleted;
  }

  Future<int> add(Model backpack) async {
    int added = await DB.insert(Backpack.table, backpack);
    loadData();
    return added;
  }
}
