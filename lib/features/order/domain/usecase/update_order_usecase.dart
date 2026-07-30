import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../../../../core/utils/result.dart';
import '../entities/order_item_entity.dart';
import '../entities/payment_method.dart';

class UpdateOrderUsecase {
  final OrderRepository _repository;

  const UpdateOrderUsecase(this._repository);

  Future<Result<String>> call({
    required String orderId,
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    String notes = '',
  }) async {
    final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    final result = await _repository.updateOrder(
      orderId: orderId,
      notes: notes,
      items: items,
      paymentMethod: paymentMethod,
      total: total,
    );

    return switch (result) {
      Success() => Success(orderId),
      ResultFailure(:final failure) => ResultFailure(failure),
    };
  }
}
