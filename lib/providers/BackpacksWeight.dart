import 'package:flutter/cupertino.dart';
import 'package:ultrapack_mobile/services/db.dart';

class BackpacksWeight extends ChangeNotifier {
  Map<int, int> weightsMap = {};

  void loadData() async {
    List<Map<String, dynamic>> list = await DB.getAllBackpackWeights();
    list.forEach((i) => weightsMap[i['backpackId']] = i['TotalWeight']);
    notifyListeners();
  }

  int? getBackpackWeight(int backpackId) {
    if (weightsMap.containsKey(backpackId)) {
      return weightsMap[backpackId];
    } else {
      return 0;
    }
  }
}
