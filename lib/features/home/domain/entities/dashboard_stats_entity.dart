class DashboardStatsEntity {
  final int totalTransactions;
  final double totalAmount;
  final double averageItemsPerOrder;
  final double averageOrderValue;

  const DashboardStatsEntity({
    required this.totalTransactions,
    required this.totalAmount,
    required this.averageItemsPerOrder,
    required this.averageOrderValue,
  });

  static const empty = DashboardStatsEntity(
    totalTransactions: 0,
    totalAmount: 0,
    averageItemsPerOrder: 0,
    averageOrderValue: 0,
  );
}
