import 'package:flutter/material.dart';
import 'package:ultrapack_mobile/models/ItemsBackpacks.dart';
import 'package:ultrapack_mobile/services/db.dart';

import '../models/Model.dart';

class InventorySelections extends ChangeNotifier {
  Set<int> inventorySelections = {};

  Set<int> get getSelections {
    return inventorySelections;
  }

  int get size {
    return inventorySelections.length;
  }

  void toggleSelection(int id) {
    if (inventorySelections.contains(id)) {
      inventorySelections.remove(id);
    } else {
      inventorySelections.add(id);
    }
    notifyListeners();
  }

  void clear() {
    inventorySelections = {};
  }

  bool contains(int id) {
    return inventorySelections.contains(id);
  }

  void addSelectionsToPack(int backpackId) {
    for (int id in inventorySelections) {
      Model ibp = ItemsBackpacks(itemId: id, backpackId: backpackId);
      DB.insert(ItemsBackpacks.table, ibp);
    }
    inventorySelections.clear();
  }
}
