class OrderItemEntity {
  final String id;

  final String productId;
  final String name;
  final int quantity;
  final double price;

  const OrderItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get subtotal => quantity * price;
}
