import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/income/domain/repository/income_repository.dart';

class PullIncomeUsecase {
  final IncomeRepository _repository;

  const PullIncomeUsecase(this._repository);

  Future<Result<void>> call() => _repository.pullAll();
}
