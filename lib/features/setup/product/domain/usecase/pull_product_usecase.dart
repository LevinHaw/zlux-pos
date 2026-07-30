import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/product_repository.dart';

class PullProductsUsecase {
  final ProductRepository _repository;

  const PullProductsUsecase(this._repository);

  Future<Result<void>> call() => _repository.pullAll();
}
