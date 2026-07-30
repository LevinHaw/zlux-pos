import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../entities/order_entity.dart';

class WatchOrderDateMonthUsecase {
  final OrderRepository _repository;

  const WatchOrderDateMonthUsecase(this._repository);

  Stream<List<DateTime>> call({required int year, required int month}) {
    return _repository.watchOrderDateMonth(year: year, month: month);
  }
}
