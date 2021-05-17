import 'Model.dart';

class ItemsBackpacks extends Model {
  static String table = 'items_backpacks';

  final int itemId;
  final int backpackId;

  ItemsBackpacks({required this.itemId, required this.backpackId});

  Map<String, dynamic> toMap() {
    return {'itemId': itemId, 'backpackId': backpackId};
  }

  static ItemsBackpacks fromMap(Map<String, dynamic> map) {
    return ItemsBackpacks(itemId: map['itemId'], backpackId: map['backpackId']);
  }
}
