import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';

abstract class ExpenseEntryRepository {
  Stream<List<ExpenseEntryEntity>> watchExpenseEntries();

  Future<ExpenseEntryEntity?> getExpenseEntry(String id);

  Future<Result<ExpenseEntryEntity>> saveExpenseEntry({
    String? id,
    required String expenseId,
    required String expenseName,
    required double amount,
    String note,
    required DateTime date,
  });

  Future<Result<void>> deleteExpenseEntry(String id);

  Future<void> syncPending();

  Future<Result<void>> pullAll();
}
