import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../../../../core/utils/result.dart';

class DeleteOrderUsecase {
  final OrderRepository _repository;

  const DeleteOrderUsecase(this._repository);

  Future<Result<void>> call(String orderId) => _repository.deleteOrder(orderId);
}
