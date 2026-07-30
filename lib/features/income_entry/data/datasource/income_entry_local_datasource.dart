import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/dao/income_entry_dao.dart';
import 'package:zlux_pos/features/income_entry/data/models/income_entry_model.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';

extension IncomeEntryRowX on IncomeEntryData {
  IncomeEntryEntity toEntity() => IncomeEntryEntity(
        id: id,
        incomeId: incomeId,
        incomeName: incomeName,
        amount: amount,
        note: note,
        date: date,
      );
}

class IncomeEntryLocalDatasource {
  final IncomeEntryDao _dao;
  final _uuid = const Uuid();

  IncomeEntryLocalDatasource(this._dao);

  Stream<List<IncomeEntryEntity>> watchIncomeEntries(String ownerId) {
    return _dao
        .watchIncomeEntries(ownerId)
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<IncomeEntryEntity?> getIncomeEntry(String id) async {
    final row = await _dao.getIncomeEntry(id);
    return row?.toEntity();
  }

  Future<IncomeEntryEntity> upsertIncomeEntry({
    String? id,
    required String ownerId,
    required String incomeId,
    required String incomeName,
    required double amount,
    String note = '',
    required DateTime date,
  }) async {
    var entryId = id;

    if (entryId == null) {
      final existing = await _dao.findEntryForDate(
        ownerId: ownerId,
        incomeId: incomeId,
        date: date,
      );
      entryId = existing?.id ?? _uuid.v4();
    }

    await _dao.upsertIncomeEntry(
      IncomeEntriesCompanion(
        id: Value(entryId),
        ownerId: Value(ownerId),
        incomeId: Value(incomeId),
        incomeName: Value(incomeName),
        amount: Value(amount),
        note: Value(note),
        date: Value(date),
        isSynced: const Value(false),
        isDeleted: const Value(false),
      ),
    );

    return IncomeEntryEntity(
      id: entryId,
      incomeId: incomeId,
      incomeName: incomeName,
      amount: amount,
      note: note,
      date: date,
    );
  }

  Future<void> deleteIncomeEntry(String id) => _dao.deleteIncomeEntry(id);

  Future<void> markSynced(String id) => _dao.markSynced(id);

  Future<List<IncomeEntryEntity>> getUnsynced(String ownerId) async {
    final rows = await _dao.getUnsyncedIncomeEntries(ownerId);
    return rows.map((r) => r.toEntity()).toList();
  }

  Future<void> pullAll(String ownerId, List<IncomeEntryModel> entries) {
    final companions = entries
        .map(
          (e) => IncomeEntriesCompanion(
            id: Value(e.id),
            ownerId: Value(ownerId),
            incomeId: Value(e.incomeId),
            incomeName: Value(e.incomeName),
            amount: Value(e.amount),
            note: Value(e.note),
            date: Value(e.date),
            isSynced: const Value(true),
            isDeleted: const Value(false),
          ),
        )
        .toList();

    return _dao.upsertAllIncomeEntries(companions);
  }
}

