import 'package:zlux_pos/features/setup/product/domain/repository/category_repository.dart';

import '../entities/category_entity.dart';

class WatchCategoriesUsecase {
  final CategoryRepository _repository;

  const WatchCategoriesUsecase(this._repository);

  Stream<List<CategoryEntity>> call() => _repository.watchCategories();
}
