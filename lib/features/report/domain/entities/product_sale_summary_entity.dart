class ProductSaleSummaryEntity {
  final String productId;
  final String productName;
  final int quantity;
  final double amount;

  const ProductSaleSummaryEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
  });
}
