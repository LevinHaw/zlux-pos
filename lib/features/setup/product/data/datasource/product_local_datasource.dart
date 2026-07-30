import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/dao/product_dao.dart';

import '../models/product_model.dart';
import '../../domain/entities/product_entity.dart';

extension ProductRowX on ProductData {
  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        price: price,
        category: category,
        updatedAt: updatedAt,
      );
}

class ProductLocalDataSource {
  final ProductDao _dao;
  final _uuid = const Uuid();

  ProductLocalDataSource(this._dao);

  Stream<List<ProductEntity>> watchProducts(String ownerId) {
    return _dao
        .watchProducts(ownerId)
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<ProductEntity?> getProduct(String id) async {
    final row = await _dao.getProduct(id);
    return row?.toEntity();
  }

  Future<ProductEntity> upsertProduct({
    String? id,
    required String ownerId,
    required String name,
    required double price,
    required String category,
  }) async {
    final productId = id ?? _uuid.v4();
    final now = DateTime.now();

    await _dao.upsertProduct(
      ProductCompanion(
        id: Value(productId),
        ownerId: Value(ownerId),
        name: Value(name),
        price: Value(price),
        category: Value(category),
        isSynced: const Value(false),
        isDeleted: const Value(false),
        updatedAt: Value(now),
      ),
    );

    return ProductEntity(
      id: productId,
      name: name,
      price: price,
      category: category,
      updatedAt: now,
    );
  }

  Future<void> deleteProduct(String id) => _dao.deleteProduct(id);

  Future<void> markSynced(String id) => _dao.markSynced(id);

  Future<List<ProductEntity>> getUnsynced(String ownerId) async {
    final rows = await _dao.getUnsyncedProducts(ownerId);
    return rows.map((r) => r.toEntity()).toList();
  }
  Future<void> pullAll(String ownerId, List<ProductModel> products) {
    final entries = products
        .map(
          (p) => ProductCompanion(
            id: Value(p.id),
            ownerId: Value(ownerId),
            name: Value(p.name),
            price: Value(p.price),
            category: Value(p.category),
            isSynced: const Value(true),
            isDeleted: const Value(false),
            updatedAt: Value(p.updatedAt ?? DateTime.now()),
          ),
        )
        .toList();

    return _dao.upsertAllProducts(entries);
  }
}
