import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/merchant_entity.dart';

class MerchantModel extends MerchantEntity {
  const MerchantModel({
    required super.id,
    required super.name,
    required super.address,
    super.imageUrl,
    super.updatedAt,
  });

  factory MerchantModel.fromMap(String id, Map<String, dynamic> map) {
    return MerchantModel(
      id: id,
      name: map['name'] as String? ?? '',
      address: map['address'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory MerchantModel.fromEntity(MerchantEntity entity) {
    return MerchantModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      imageUrl: entity.imageUrl,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
