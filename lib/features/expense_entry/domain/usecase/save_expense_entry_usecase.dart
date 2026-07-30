import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/expense_entry/domain/repository/expense_entry_repository.dart';

class SaveExpenseEntryUsecase {
  final ExpenseEntryRepository _repository;

  const SaveExpenseEntryUsecase(this._repository);

  Future<Result<ExpenseEntryEntity>> call({
    String? id,
    required String expenseId,
    required String expenseName,
    required double amount,
    String note = '',
    required DateTime date,
  }) {
    return _repository.saveExpenseEntry(
      id: id,
      expenseId: expenseId,
      expenseName: expenseName,
      amount: amount,
      note: note,
      date: date,
    );
  }
}
