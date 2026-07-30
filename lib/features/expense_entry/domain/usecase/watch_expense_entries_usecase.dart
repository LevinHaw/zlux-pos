import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/expense_entry/domain/repository/expense_entry_repository.dart';

class WatchExpenseEntriesUsecase {
  final ExpenseEntryRepository _repository;

  const WatchExpenseEntriesUsecase(this._repository);

  Stream<List<ExpenseEntryEntity>> call() => _repository.watchExpenseEntries();
}
