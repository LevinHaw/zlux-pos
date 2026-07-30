import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../entities/order_entity.dart';

class GetOrderByIdUsecase {
  final OrderRepository _repository;

  const GetOrderByIdUsecase(this._repository);

  Future<OrderEntity?> call(String orderId) => _repository.getOrderById(orderId);
}
