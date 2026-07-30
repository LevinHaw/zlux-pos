import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../entities/order_entity.dart';

class WatchOrdersByDateUsecase {
  final OrderRepository _repository;

  const WatchOrdersByDateUsecase(this._repository);

  Stream<List<OrderEntity>> call(DateTime date) =>
      _repository.watchOrdersByDate(date);
}
