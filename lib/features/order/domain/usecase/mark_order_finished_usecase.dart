import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../../../../core/utils/result.dart';

class MarkOrderFinishedUsecase {
  final OrderRepository _repository;

  const MarkOrderFinishedUsecase(this._repository);

  Future<Result<void>> call(String orderId) =>
      _repository.markOrderFinished(orderId);
}
