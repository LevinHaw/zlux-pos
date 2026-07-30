import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/product/domain/entities/product_entity.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/product_repository.dart';

class SaveProductUsecase {
  final ProductRepository _repository;

  const SaveProductUsecase(this._repository);

  Future<Result<ProductEntity>> call({
    String? id,
    required String name,
    required double price,
    required String category,
  }) {
    return _repository.saveProduct(
      id: id,
      name: name,
      price: price,
      category: category,
    );
  }
}
