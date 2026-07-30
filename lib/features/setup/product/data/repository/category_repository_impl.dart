import 'dart:async';

import 'package:zlux_pos/core/error/failures.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/product/data/datasource/category_local_datasource.dart';
import 'package:zlux_pos/features/setup/product/data/datasource/category_remote_datasource.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/category_repository.dart';

import '../../domain/entities/category_entity.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource _local;
  final CategoryRemoteDataSource _remote;
  final String Function() _ownerId;

  CategoryRepositoryImpl({
    required CategoryLocalDataSource local,
    required CategoryRemoteDataSource remote,
    required String Function() ownerId,
  })  : _local = local,
        _remote = remote,
        _ownerId = ownerId;

  @override
  Stream<List<CategoryEntity>> watchCategories() =>
      _local.watchCategories(_ownerId());

  @override
  Future<Result<CategoryEntity>> addCategory(String name) async {
    try {
      final ownerId = _ownerId();
      final entity = await _local.addCategory(ownerId: ownerId, name: name);

      unawaited(
        _remote
            .pushCategory(id: entity.id, ownerId: ownerId, name: entity.name)
            .then((_) => _local.markSynced(entity.id))
            .catchError((_) {}),
      );

      return Success(entity);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> syncPending() async {
    final ownerId = _ownerId();
    final pending = await _local.getUnsynced(ownerId);
    for (final row in pending) {
      try {
        await _remote.pushCategory(
          id: row.id,
          ownerId: row.ownerId,
          name: row.name,
        );
        await _local.markSynced(row.id);
      } catch (_) {

      }
    }
  }

  @override
  Future<Result<void>> pullAll() async {
    try {
      final ownerId = _ownerId();
      final remoteCategories = await _remote.fetchCategories(ownerId);
      await _local.pullAll(ownerId, remoteCategories);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }
}