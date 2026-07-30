import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/dao/income_dao.dart';
import 'package:zlux_pos/features/setup/income/data/models/income_model.dart';
import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';

extension IncomeRowX on IncomeData {
  IncomeEntity toEntity() =>
      IncomeEntity(id: id, name: name);
}

class IncomeLocalDatasource {
  final IncomeDao _dao;
  final _uuid = const Uuid();

  IncomeLocalDatasource(this._dao);

  Stream<List<IncomeEntity>> watchIncome(String ownerId) {
    return _dao
        .watchIncome(ownerId)
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<IncomeEntity?> getIncome(String id) async {
    final row = await _dao.getIncome(id);
    return row?.toEntity();
  }

  Future<IncomeEntity> upsertIncome({
    String? id,
    required String ownerId,
    required String name,
  }) async {
    final incomeId = id ?? _uuid.v4();

    await _dao.upsertIncome(
      IncomeCompanion(
        id: Value(incomeId),
        ownerId: Value(ownerId),
        name: Value(name),
        isSynced: const Value(false),
        isDeleted: const Value(false),
      ),
    );

    return IncomeEntity(id: incomeId, name: name);
  }

  Future<void> deleteIncome(String id) => _dao.deleteIncome(id);

  Future<void> markSynced(String id) => _dao.markSynced(id);

  Future<List<IncomeEntity>> getUnsynced(String ownerId) async {
    final rows = await _dao.getUnsyncedIncome(ownerId);
    return rows.map((r) => r.toEntity()).toList();
  }

  Future<void> pullAll(String ownerId, List<IncomeModel> income) {
    final entries =
        income
            .map(
              (i) => IncomeCompanion(
                id: Value(i.id),
                ownerId: Value(ownerId),
                name: Value(i.name),
                isSynced: const Value(true),
                isDeleted: const Value(false),
              ),
            )
            .toList();

    return _dao.upsertAllIncome(entries);
  }
}
