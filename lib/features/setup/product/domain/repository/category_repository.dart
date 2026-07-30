import 'package:zlux_pos/core/utils/result.dart';

import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Stream<List<CategoryEntity>> watchCategories();

  Future<Result<CategoryEntity>> addCategory(String name);

  Future<void> syncPending();

  Future<Result<void>> pullAll();
}