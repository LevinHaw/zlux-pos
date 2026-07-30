import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromFirestore(String id, Map<String, dynamic> map) {
    return CategoryModel(id: id, name: map['name'] as String? ?? '');
  }
}