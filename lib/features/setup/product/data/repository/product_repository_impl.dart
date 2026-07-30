import 'dart:async';

import 'package:zlux_pos/core/error/failures.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/product/data/datasource/product_local_datasource.dart';
import 'package:zlux_pos/features/setup/product/data/datasource/product_remote_datasource.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/product_repository.dart';

import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource _local;
  final ProductRemoteDataSource _remote;
  final String Function() _ownerId;

  ProductRepositoryImpl({
    required ProductLocalDataSource local,
    required ProductRemoteDataSource remote,
    required String Function() ownerId,
  })  : _local = local,
        _remote = remote,
        _ownerId = ownerId;

  @override
  Stream<List<ProductEntity>> watchProducts() =>
      _local.watchProducts(_ownerId());

  @override
  Future<ProductEntity?> getProduct(String id) => _local.getProduct(id);

  @override
  Future<Result<ProductEntity>> saveProduct({
    String? id,
    required String name,
    required double price,
    required String category,
  }) async {
    try {
      final ownerId = _ownerId();

      final entity = await _local.upsertProduct(
        id: id,
        ownerId: ownerId,
        name: name,
        price: price,
        category: category,
      );

      unawaited(_pushOne(ownerId, entity));

      return Success(entity);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  Future<void> _pushOne(String ownerId, ProductEntity entity) async {
    try {
      await _remote.pushProduct(
        ownerId,
        ProductModel(
          id: entity.id,
          name: entity.name,
          price: entity.price,
          category: entity.category,
          updatedAt: entity.updatedAt,
        ),
      );
      await _local.markSynced(entity.id);
    } catch (_) {

    }
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    try {
      await _local.deleteProduct(id);
      unawaited(_remote.deleteProduct(id).catchError((_) {}));
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> syncPending() async {
    final ownerId = _ownerId();
    final pending = await _local.getUnsynced(ownerId);
    for (final entity in pending) {
      await _pushOne(ownerId, entity);
    }
  }

  @override
  Future<Result<void>> pullAll() async {
    try {
      final ownerId = _ownerId();
      final remoteProducts = await _remote.fetchProducts(ownerId);
      await _local.pullAll(ownerId, remoteProducts);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }
}
