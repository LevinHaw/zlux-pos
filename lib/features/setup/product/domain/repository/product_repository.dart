
import 'package:zlux_pos/core/utils/result.dart';

import '../entities/product_entity.dart';

abstract class ProductRepository {
  Stream<List<ProductEntity>> watchProducts();

  Future<ProductEntity?> getProduct(String id);

  Future<Result<ProductEntity>> saveProduct({
    String? id,
    required String name,
    required double price,
    required String category,
  });

  Future<Result<void>> deleteProduct(String id);

  Future<void> syncPending();

  Future<Result<void>> pullAll();
}
