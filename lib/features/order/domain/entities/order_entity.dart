import 'order_item_entity.dart';
import 'payment_method.dart';

enum OrderStatus { pending, finish }

class OrderEntity {
  final String id;
  final OrderStatus status;
  final String notes;
  final List<OrderItemEntity> items;
  final double total;
  final DateTime createdAt;
  final PaymentMethod paymentMethod;

  final bool isSynced;

  const OrderEntity({
    required this.id,
    required this.status,
    required this.notes,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.paymentMethod,
    this.isSynced = true,
  });
}
