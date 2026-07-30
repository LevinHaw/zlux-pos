import 'package:drift/drift.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/table/expense_table.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expense])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  Stream<List<ExpenseData>> watchExpense(String ownerId) {
    return (select(expense)
          ..where((e) => e.ownerId.equals(ownerId) & e.isDeleted.equals(false)))
        .watch();
  }

  Future<ExpenseData?> getExpense(String id) {
    return (select(expense)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertExpense(ExpenseCompanion entry) {
    return into(expense).insertOnConflictUpdate(entry);
  }

  Future<void> upsertAllExpense(List<ExpenseCompanion> entries) {
    return batch((b) {
      b.insertAllOnConflictUpdate(expense, entries);
    });
  }

  Future<void> deleteExpense(String id) {
    return (update(expense)..where((e) => e.id.equals(id))).write(
      ExpenseCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
      ),
    );
  }

  Future<List<ExpenseData>> getUnsyncedExpense(String ownerId) {
    return (select(expense)
          ..where((e) => e.ownerId.equals(ownerId) & e.isSynced.equals(false)))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(expense)..where((e) => e.id.equals(id)))
        .write(const ExpenseCompanion(isSynced: Value(true)));
  }
}