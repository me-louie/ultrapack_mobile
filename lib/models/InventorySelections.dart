// import 'package:flutter/material.dart';
//
// import 'Item.dart';
//
// class InventorySelections extends ChangeNotifier {
//   Set<Item> inventorySelections = {};
//
//   Set<Item> get getSelections {
//     return inventorySelections;
//   }
//
//   void add(InventoryItem item) {
//     if (!inventorySelections.contains(item)){
//       inventorySelections.add(item);
//       notifyListeners();
//     }
//   }
//
//   void remove(InventoryItem item){
//     if (inventorySelections.contains(item)){
//       inventorySelections.remove(item);
//       notifyListeners();
//     }
//   }
// }