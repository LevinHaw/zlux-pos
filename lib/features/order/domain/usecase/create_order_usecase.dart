import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../../../../core/utils/result.dart';
import '../entities/order_item_entity.dart';
import '../entities/payment_method.dart';

class CreateOrderUsecase {
  final OrderRepository _repository;

  const CreateOrderUsecase(this._repository);

  Future<Result<String>> call({
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    String notes = '',
  }) {
    final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    return _repository.createOrder(
      notes: notes,
      items: items,
      paymentMethod: paymentMethod,
      total: total,
    );
  }
}
