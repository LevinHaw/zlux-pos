import 'package:drift/drift.dart';
import 'package:zlux_pos/core/database/table/category_table.dart';

import '../app_database.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Category])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<CategoryData>> watchCategories(String ownerId) {
    return (select(category)
          ..where((c) => c.ownerId.equals(ownerId))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  Future<void> upsertCategory(CategoryCompanion entry) {
    return into(category).insertOnConflictUpdate(entry);
  }

  Future<void> upsertAllCategories(List<CategoryCompanion> entries) {
    return batch((b) {
      b.insertAllOnConflictUpdate(category, entries);
    });
  }

  Future<List<CategoryData>> getUnsyncedCategories(String ownerId) {
    return (select(category)
          ..where((c) => c.ownerId.equals(ownerId) & c.isSynced.equals(false)))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(category)..where((c) => c.id.equals(id)))
        .write(const CategoryCompanion(isSynced: Value(true)));
  }
}