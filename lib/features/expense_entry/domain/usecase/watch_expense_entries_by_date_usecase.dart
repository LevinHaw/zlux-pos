import '../entities/expense_entry_entity.dart';
import '../repository/expense_entry_repository.dart';

class WatchExpenseEntriesByDateUsecase {
  final ExpenseEntryRepository _repository;

  const WatchExpenseEntriesByDateUsecase(this._repository);

  Stream<List<ExpenseEntryEntity>> call(DateTime date) =>
      _repository.watchExpenseEntriesByDate(date);
}
