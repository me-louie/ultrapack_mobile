import 'package:flutter/material.dart';

class InventorySelections extends ChangeNotifier {
  Set<int> inventorySelections = {};

  Set<int> get getSelections {
    return inventorySelections;
  }

  int get size {
    return inventorySelections.length;
  }

  // bool hasSelections() {
  //   return inventorySelections.length > 0;
  // }
  // void add(int id) {
  //   if (!inventorySelections.contains(id)){
  //     inventorySelections.add(id);
  //     notifyListeners();
  //   }
  // }
  //
  // void remove(int id){
  //   if (inventorySelections.contains(id)){
  //     inventorySelections.remove(id);
  //     notifyListeners();
  //   }
  // }
  void toggleSelection(int id) {
    print('toggleSelection');
    if (inventorySelections.contains(id)) {
      inventorySelections.remove(id);
    } else {
      inventorySelections.add(id);
    }

    print(this.size);
    notifyListeners();
  }
}
