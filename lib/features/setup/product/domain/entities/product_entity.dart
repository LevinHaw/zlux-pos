class ProductEntity {
  final String id;
  final String name;
  final double price;
  final String category;
  final DateTime? updatedAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.updatedAt,
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
