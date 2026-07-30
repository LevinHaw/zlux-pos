import 'package:drift/drift.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/table/income_table.dart';

part 'income_dao.g.dart';

@DriftAccessor(tables: [Income])
class IncomeDao extends DatabaseAccessor<AppDatabase> with _$IncomeDaoMixin {
  IncomeDao(super.db);

  Stream<List<IncomeData>> watchIncome(String ownerId) {
    return (select(income)
          ..where((i) => i.ownerId.equals(ownerId) & i.isDeleted.equals(false)))
        .watch();
  }

  Future<IncomeData?> getIncome(String id) {
    return (select(income)..where((i) => i.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertIncome(IncomeCompanion entry) {
    return into(income).insertOnConflictUpdate(entry);
  }

  Future<void> upsertAllIncome(List<IncomeCompanion> entries) {
    return batch((b) {
      b.insertAllOnConflictUpdate(income, entries);
    });
  }

  Future<void> deleteIncome(String id) {
    return (update(income)..where((i) => i.id.equals(id))).write(
      IncomeCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
      ),
    );
  }

  Future<List<IncomeData>> getUnsyncedIncome(String ownerId) {
    return (select(income)
          ..where((i) => i.ownerId.equals(ownerId) & i.isSynced.equals(false)))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(income)..where((i) => i.id.equals(id)))
        .write(const IncomeCompanion(isSynced: Value(true)));
  }
}
