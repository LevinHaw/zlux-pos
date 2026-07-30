import 'package:drift/drift.dart';

import '../app_database.dart';
import '../table/expense_entries_table.dart';

part 'expense_entry_dao.g.dart';

@DriftAccessor(tables: [ExpenseEntries])
class ExpenseEntryDao extends DatabaseAccessor<AppDatabase>
    with _$ExpenseEntryDaoMixin {
  ExpenseEntryDao(super.db);

  Stream<List<ExpenseEntryData>> watchExpenseEntries(String ownerId) {
    final query = select(expenseEntries)
      ..where(
        (e) => e.ownerId.equals(ownerId) & e.isDeleted.equals(false),
      )
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch();
  }

  Future<ExpenseEntryData?> getExpenseEntry(String id) {
    return (select(expenseEntries)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  Future<ExpenseEntryData?> findEntryForDate({
    required String ownerId,
    required String expenseId,
    required DateTime date,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(expenseEntries)
          ..where(
            (e) =>
                e.ownerId.equals(ownerId) &
                e.expenseId.equals(expenseId) &
                e.isDeleted.equals(false) &
                e.date.isBiggerOrEqualValue(startOfDay) &
                e.date.isSmallerThanValue(endOfDay),
          ))
        .getSingleOrNull();
  }

  Future<void> upsertExpenseEntry(ExpenseEntriesCompanion entry) {
    return into(expenseEntries).insertOnConflictUpdate(entry);
  }

  Future<void> upsertAllExpenseEntries(
    List<ExpenseEntriesCompanion> entries,
  ) {
    return batch((b) {
      b.insertAllOnConflictUpdate(expenseEntries, entries);
    });
  }

  Future<void> deleteExpenseEntry(String id) {
    return (update(expenseEntries)..where((e) => e.id.equals(id))).write(
      ExpenseEntriesCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
      ),
    );
  }

  Future<List<ExpenseEntryData>> getUnsyncedExpenseEntries(String ownerId) {
    return (select(expenseEntries)
          ..where(
            (e) => e.ownerId.equals(ownerId) & e.isSynced.equals(false),
          ))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(expenseEntries)..where((e) => e.id.equals(id)))
        .write(const ExpenseEntriesCompanion(isSynced: Value(true)));
  }
}

