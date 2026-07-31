import 'package:drift/drift.dart';

import '../app_database.dart';
import '../table/income_entries_table.dart';

part 'income_entry_dao.g.dart';

@DriftAccessor(tables: [IncomeEntries])
class IncomeEntryDao extends DatabaseAccessor<AppDatabase>
    with _$IncomeEntryDaoMixin {
  IncomeEntryDao(super.db);

  Stream<List<IncomeEntryData>> watchIncomeEntries(String ownerId) {
    final query = select(incomeEntries)
      ..where(
        (e) => e.ownerId.equals(ownerId) & e.isDeleted.equals(false),
      )
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch();
  }

  Future<IncomeEntryData?> getIncomeEntry(String id) {
    return (select(incomeEntries)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<List<IncomeEntryData>> watchIncomeEntriesByDate(
    String ownerId,
    DateTime date,
  ) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = select(incomeEntries)
      ..where(
        (e) =>
            e.ownerId.equals(ownerId) &
            e.isDeleted.equals(false) &
            e.date.isBiggerOrEqualValue(startOfDay) &
            e.date.isSmallerThanValue(endOfDay),
      )
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch();
  }

  Future<IncomeEntryData?> findEntryForDate({
    required String ownerId,
    required String incomeId,
    required DateTime date,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(incomeEntries)
          ..where(
            (e) =>
                e.ownerId.equals(ownerId) &
                e.incomeId.equals(incomeId) &
                e.isDeleted.equals(false) &
                e.date.isBiggerOrEqualValue(startOfDay) &
                e.date.isSmallerThanValue(endOfDay),
          ))
        .getSingleOrNull();
  }

  Stream<List<DateTime>> watchDatesInMonth(
    String ownerId,
    int year,
    int month,
  ) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final query = selectOnly(incomeEntries, distinct: true)
      ..addColumns([incomeEntries.date])
      ..where(
        incomeEntries.ownerId.equals(ownerId) &
            incomeEntries.isDeleted.equals(false) &
            incomeEntries.date.isBiggerOrEqualValue(start) &
            incomeEntries.date.isSmallerThanValue(end),
      );

    return query.watch().map((rows) {
      final days = rows
          .map((r) => r.read(incomeEntries.date)!)
          .map((dt) => DateTime(dt.year, dt.month, dt.day))
          .toSet()
          .toList();
      days.sort((a, b) => a.compareTo(b));
      return days;
    });
  }

  Future<void> upsertIncomeEntry(IncomeEntriesCompanion entry) {
    return into(incomeEntries).insertOnConflictUpdate(entry);
  }

  Future<void> upsertAllIncomeEntries(List<IncomeEntriesCompanion> entries) {
    return batch((b) {
      b.insertAllOnConflictUpdate(incomeEntries, entries);
    });
  }

  Future<void> deleteIncomeEntry(String id) {
    return (update(incomeEntries)..where((e) => e.id.equals(id))).write(
      IncomeEntriesCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
      ),
    );
  }

  Future<List<IncomeEntryData>> getUnsyncedIncomeEntries(String ownerId) {
    return (select(incomeEntries)
          ..where(
            (e) => e.ownerId.equals(ownerId) & e.isSynced.equals(false),
          ))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(incomeEntries)..where((e) => e.id.equals(id)))
        .write(const IncomeEntriesCompanion(isSynced: Value(true)));
  }
}





