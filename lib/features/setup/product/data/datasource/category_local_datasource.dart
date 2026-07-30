import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/dao/category_dao.dart';
import 'package:zlux_pos/core/database/table/category_table.dart';

import '../models/category_model.dart';
import '../../domain/entities/category_entity.dart';

extension CategoryRowX on CategoryData {
  CategoryEntity toEntity() => CategoryEntity(id: id, name: name);
}

class CategoryLocalDataSource {
  final CategoryDao _dao;
  final _uuid = const Uuid();

  CategoryLocalDataSource(this._dao);

  Stream<List<CategoryEntity>> watchCategories(String ownerId) {
    return _dao
        .watchCategories(ownerId)
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<CategoryEntity> addCategory({
    required String ownerId,
    required String name,
  }) async {
    final id = _uuid.v4();
    await _dao.upsertCategory(
      CategoryCompanion(
        id: Value(id),
        ownerId: Value(ownerId),
        name: Value(name),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return CategoryEntity(id: id, name: name);
  }

  Future<List<CategoryData>> getUnsynced(String ownerId) =>
      _dao.getUnsyncedCategories(ownerId);

  Future<void> markSynced(String id) => _dao.markSynced(id);

  Future<void> pullAll(String ownerId, List<CategoryModel> categories) {
    final entries = categories
        .map(
          (c) => CategoryCompanion(
            id: Value(c.id),
            ownerId: Value(ownerId),
            name: Value(c.name),
            isSynced: const Value(true),
            updatedAt: Value(DateTime.now()),
          ),
        )
        .toList();

    return _dao.upsertAllCategories(entries);
  }
}