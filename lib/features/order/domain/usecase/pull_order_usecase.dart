import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../../../../core/utils/result.dart';

class PullOrdersUsecase {
  final OrderRepository _repository;

  const PullOrdersUsecase(this._repository);

  Future<Result<void>> call() => _repository.pullAll();
}
