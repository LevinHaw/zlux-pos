import 'package:zlux_pos/features/setup/product/domain/repository/product_repository.dart';
import '../entities/product_entity.dart';

class WatchProductsUsecase {
  final ProductRepository _repository;

  const WatchProductsUsecase(this._repository);

  Stream<List<ProductEntity>> call() => _repository.watchProducts();
}
