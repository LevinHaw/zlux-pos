import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/dao/expense_entry_dao.dart';
import 'package:zlux_pos/features/expense_entry/data/models/expense_entry_model.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';

extension ExpenseEntryRowX on ExpenseEntryData {
  ExpenseEntryEntity toEntity() => ExpenseEntryEntity(
        id: id,
        expenseId: expenseId,
        expenseName: expenseName,
        amount: amount,
        note: note,
        date: date,
      );
}

class ExpenseEntryLocalDatasource {
  final ExpenseEntryDao _dao;
  final _uuid = const Uuid();

  ExpenseEntryLocalDatasource(this._dao);

  Stream<List<ExpenseEntryEntity>> watchExpenseEntries(String ownerId) {
    return _dao
        .watchExpenseEntries(ownerId)
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<ExpenseEntryEntity?> getExpenseEntry(String id) async {
    final row = await _dao.getExpenseEntry(id);
    return row?.toEntity();
  }

  Future<ExpenseEntryEntity> upsertExpenseEntry({
    String? id,
    required String ownerId,
    required String expenseId,
    required String expenseName,
    required double amount,
    String note = '',
    required DateTime date,
  }) async {
    var entryId = id;

    if (entryId == null) {
      final existing = await _dao.findEntryForDate(
        ownerId: ownerId,
        expenseId: expenseId,
        date: date,
      );
      entryId = existing?.id ?? _uuid.v4();
    }

    await _dao.upsertExpenseEntry(
      ExpenseEntriesCompanion(
        id: Value(entryId),
        ownerId: Value(ownerId),
        expenseId: Value(expenseId),
        expenseName: Value(expenseName),
        amount: Value(amount),
        note: Value(note),
        date: Value(date),
        isSynced: const Value(false),
        isDeleted: const Value(false),
      ),
    );

    return ExpenseEntryEntity(
      id: entryId,
      expenseId: expenseId,
      expenseName: expenseName,
      amount: amount,
      note: note,
      date: date,
    );
  }

  Future<void> deleteExpenseEntry(String id) => _dao.deleteExpenseEntry(id);

  Future<void> markSynced(String id) => _dao.markSynced(id);

  Future<List<ExpenseEntryEntity>> getUnsynced(String ownerId) async {
    final rows = await _dao.getUnsyncedExpenseEntries(ownerId);
    return rows.map((r) => r.toEntity()).toList();
  }

  Future<void> pullAll(String ownerId, List<ExpenseEntryModel> entries) {
    final companions = entries
        .map(
          (e) => ExpenseEntriesCompanion(
            id: Value(e.id),
            ownerId: Value(ownerId),
            expenseId: Value(e.expenseId),
            expenseName: Value(e.expenseName),
            amount: Value(e.amount),
            note: Value(e.note),
            date: Value(e.date),
            isSynced: const Value(true),
            isDeleted: const Value(false),
          ),
        )
        .toList();

    return _dao.upsertAllExpenseEntries(companions);
  }
}

