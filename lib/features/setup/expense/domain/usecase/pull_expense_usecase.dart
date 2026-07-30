import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/expense/domain/repository/expense_repository.dart';

class PullExpenseUsecase {
  final ExpenseRepository _repository;

  const PullExpenseUsecase(this._repository);

  Future<Result<void>> call() => _repository.pullAll();
}