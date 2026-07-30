import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/expense/domain/repository/expense_repository.dart';

class DeleteExpenseUsecase {
  final ExpenseRepository _repository;

  const DeleteExpenseUsecase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteExpense(id);
}