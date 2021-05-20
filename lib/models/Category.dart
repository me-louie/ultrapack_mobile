import 'Model.dart';

class Category extends Model {
  static String table = 'categories';

  final int? id;
  final String name;
  final int tagColor;

  Category({this.id, required this.name, required this.tagColor});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tagColor': tagColor,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
        id: map['id'], name: map['name'], tagColor: map['tagColor']);
  }
}
