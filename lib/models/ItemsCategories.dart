import 'Model.dart';

class ItemsCategories extends Model {
  static String table = 'items_categories';

  final int itemId;
  final int categoryId;

  ItemsCategories({required this.itemId, required this.categoryId});

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'categoryId': categoryId,
    };
  }

  static ItemsCategories fromMap(Map<String, dynamic> map){
    return ItemsCategories(itemId: map['itemId'], categoryId: map['categoryId']);
  }
}