import 'package:flutter/material.dart';

class InventorySelections extends ChangeNotifier {
  Set<int> inventorySelections = {};

  Set<int> get getSelections {
    return inventorySelections;
  }

  int get size {
    return inventorySelections.length;
  }

  void toggleSelection(int id) {
    print('toggleSelection');
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
}
