import '../../../../core/utils/result.dart';
import '../entities/order_entity.dart';
import '../entities/order_item_entity.dart';
import '../entities/payment_method.dart';

abstract class OrderRepository {
  Stream<List<OrderEntity>> watchOrdersByDate(DateTime date);

  Stream<List<DateTime>> watchOrderDateMonth({
    required int year,
    required int month,
  });

  Future<OrderEntity?> getOrderById(String orderId);

  Future<Result<void>> markOrderFinished(String orderId);

  Future<Result<String>> createOrder({
    required String notes,
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    required double total,
  });

  Future<Result<void>> updateOrder({
    required String orderId,
    required String notes,
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    required double total,
  });

  Future<void> syncPending();
  Future<Result<void>> deleteOrder(String orderId);

  Future<Result<void>> pullAll();
}
