import 'package:ultrapack_mobile/models/Model.dart';

class Backpack extends Model {
  static String table = 'backpacks';

  final int? id;
  final String name;
  final String description;

  Backpack({this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  static Backpack fromMap(Map<String, dynamic> map) {
    return Backpack(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
