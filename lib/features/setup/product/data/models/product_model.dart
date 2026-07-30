import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    super.updatedAt,
  });

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      category: map['category'] as String? ?? '',
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestoreMap(String ownerId) {
    return {
      'ownerId': ownerId,
      'name': name,
      'price': price,
      'category': category,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
