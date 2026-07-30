import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/expense_entry/domain/repository/expense_entry_repository.dart';

class PullExpenseEntriesUsecase {
  final ExpenseEntryRepository _repository;

  const PullExpenseEntriesUsecase(this._repository);

  Future<Result<void>> call() => _repository.pullAll();
}
