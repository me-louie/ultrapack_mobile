import 'Model.dart';

class Category extends Model {
  static String table = 'categories';

  final int? id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
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
