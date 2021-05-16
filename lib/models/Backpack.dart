import 'package:ultrapack_mobile/models/Model.dart';

class Backpack extends Model {
  static String table = 'backpacks';

  final int? id;
  final String name;
  final String description;
  final int weight;

  Backpack(
      {this.id,
      required this.name,
      required this.description,
      required this.weight});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'weight': weight,
    };
  }

  static Backpack fromMap(Map<String, dynamic> map) {
    return Backpack(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      weight: map['weight'],
    );
  }
}
