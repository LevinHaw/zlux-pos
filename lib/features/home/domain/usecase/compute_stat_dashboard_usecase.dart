import '../../../order/domain/entities/order_entity.dart';
import '../entities/dashboard_stats_entity.dart';

class ComputeDashboardStatsUsecase {
  const ComputeDashboardStatsUsecase();

  DashboardStatsEntity call(List<OrderEntity> orders) {
    if (orders.isEmpty) return DashboardStatsEntity.empty;

    final totalAmount = orders.fold<double>(0, (sum, o) => sum + o.total);
    final totalItems = orders.fold<int>(
      0,
      (sum, o) => sum + o.items.fold<int>(0, (s, i) => s + i.quantity),
    );

    return DashboardStatsEntity(
      totalTransactions: orders.length,
      totalAmount: totalAmount,
      averageItemsPerOrder: totalItems / orders.length,
      averageOrderValue: totalAmount / orders.length,
    );
  }
}
