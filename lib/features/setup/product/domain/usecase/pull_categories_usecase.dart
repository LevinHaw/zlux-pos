import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/category_repository.dart';

class PullCategoriesUsecase {
  final CategoryRepository _repository;

  const PullCategoriesUsecase(this._repository);

  Future<Result<void>> call() => _repository.pullAll();
}