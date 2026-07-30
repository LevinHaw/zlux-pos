
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/category_repository.dart';

import '../entities/category_entity.dart';


class AddCategoryUsecase {
  final CategoryRepository _repository;

  const AddCategoryUsecase(this._repository);

  Future<Result<CategoryEntity>> call(String name) {
    return _repository.addCategory(name);
  }
}
