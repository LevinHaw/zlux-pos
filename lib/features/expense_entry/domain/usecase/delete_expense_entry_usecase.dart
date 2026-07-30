import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/expense_entry/domain/repository/expense_entry_repository.dart';

class DeleteExpenseEntryUsecase {
  final ExpenseEntryRepository _repository;

  const DeleteExpenseEntryUsecase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteExpenseEntry(id);
}
