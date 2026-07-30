class MerchantEntity {
  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final DateTime? updatedAt;

  const MerchantEntity({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.updatedAt,
  });

  MerchantEntity copyWith({
    String? id,
    String? name,
    String? address,
    String? imageUrl,
    DateTime? updatedAt,
  }) {
    return MerchantEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
