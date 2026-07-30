import 'package:drift/drift.dart';
import 'package:zlux_pos/core/database/table/product_table.dart';

import '../app_database.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Product])
class ProductDao extends DatabaseAccessor<AppDatabase>
    with _$ProductDaoMixin {
  ProductDao(super.db);

  Stream<List<ProductData>> watchProducts(String ownerId) {
    return (select(product)
          ..where((p) => p.ownerId.equals(ownerId) & p.isDeleted.equals(false))
          ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)]))
        .watch();
  }

  Future<ProductData?> getProduct(String id) {
    return (select(product)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertProduct(ProductCompanion entry) {
    return into(product).insertOnConflictUpdate(entry);
  }

  Future<void> upsertAllProducts(List<ProductCompanion> entries) {
    return batch((b) {
      b.insertAllOnConflictUpdate(product, entries);
    });
  }

  Future<void> deleteProduct(String id) {
    return (update(product)..where((p) => p.id.equals(id))).write(
      ProductCompanion(
        isDeleted: const Value(true),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<ProductData>> getUnsyncedProducts(String ownerId) {
    return (select(product)
          ..where((p) => p.ownerId.equals(ownerId) & p.isSynced.equals(false)))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(product)..where((p) => p.id.equals(id)))
        .write(const ProductCompanion(isSynced: Value(true)));
  }
}
