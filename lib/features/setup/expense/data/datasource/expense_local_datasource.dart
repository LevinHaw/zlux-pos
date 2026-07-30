import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/dao/expense_dao.dart';

import '../../domain/entities/expense_entity.dart';
import '../models/expense_model.dart';

extension ExpenseRowX on ExpenseData {
  ExpenseEntity toEntity() =>
      ExpenseEntity(id: id, name: name);
}

class ExpenseLocalDatasource {
  final ExpenseDao _dao;
  final _uuid = const Uuid();

  ExpenseLocalDatasource(this._dao);

  Stream<List<ExpenseEntity>> watchExpense(String ownerId) {
    return _dao
        .watchExpense(ownerId)
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<ExpenseEntity?> getExpense(String id) async {
    final row = await _dao.getExpense(id);
    return row?.toEntity();
  }

  Future<ExpenseEntity> upsertExpense({
    String? id,
    required String ownerId,
    required String name,
  }) async {
    final expenseId = id ?? _uuid.v4();

    await _dao.upsertExpense(
      ExpenseCompanion(
        id: Value(expenseId),
        ownerId: Value(ownerId),
        name: Value(name),
        isSynced: const Value(false),
        isDeleted: const Value(false),
      ),
    );

    return ExpenseEntity(id: expenseId, name: name);
  }

  Future<void> deleteExpense(String id) => _dao.deleteExpense(id);

  Future<void> markSynced(String id) => _dao.markSynced(id);

  Future<List<ExpenseEntity>> getUnsynced(String ownerId) async {
    final rows = await _dao.getUnsyncedExpense(ownerId);
    return rows.map((r) => r.toEntity()).toList();
  }

  Future<void> pullAll(String ownerId, List<ExpenseModel> expense) {
    final entries =
        expense
            .map(
              (i) => ExpenseCompanion(
                id: Value(i.id),
                ownerId: Value(ownerId),
                name: Value(i.name),
                isSynced: const Value(true),
                isDeleted: const Value(false),
              ),
            )
            .toList();

    return _dao.upsertAllExpense(entries);
  }
}