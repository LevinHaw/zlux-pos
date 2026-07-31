import 'package:zlux_pos/features/expense_entry/domain/repository/expense_entry_repository.dart';

class WatchExpenseDatesInMonthUsecase {
  final ExpenseEntryRepository _repository;

  const WatchExpenseDatesInMonthUsecase(this._repository);

  Stream<List<DateTime>> call({required int year, required int month}) {
    return _repository.watchExpenseDatesInMonth(year: year, month: month);
  }
}
