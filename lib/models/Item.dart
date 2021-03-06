import 'Model.dart';

class Item extends Model {
  static String table = 'items_inventory';

  final int? id;
  final String name;
  final int weight;

  Item({this.id, required this.name, required this.weight});

  // Converts an Item into a Map. The keys must correspond to the names of
  // columns in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
    };
  }
  static Item fromMap(Map<String, dynamic> map){
    return Item(
      id: map['id'],
      name: map['name'],
      weight: map['weight']
    );
  }
}
