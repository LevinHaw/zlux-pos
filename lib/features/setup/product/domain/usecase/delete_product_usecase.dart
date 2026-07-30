import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository _repository;

  const DeleteProductUsecase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteProduct(id);
}
