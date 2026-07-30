import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/income/domain/repository/income_repository.dart';

class DeleteIncomeUsecase {
  final IncomeRepository _repository;

  const DeleteIncomeUsecase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteIncome(id);
}
