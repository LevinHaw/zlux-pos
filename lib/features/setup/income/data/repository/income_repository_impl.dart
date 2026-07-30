import 'dart:async';

import 'package:zlux_pos/core/error/failures.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/income/data/datasource/income_local_datasource.dart';
import 'package:zlux_pos/features/setup/income/data/datasource/income_remote_datasource.dart';
import 'package:zlux_pos/features/setup/income/data/models/income_model.dart';
import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';
import 'package:zlux_pos/features/setup/income/domain/repository/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeLocalDatasource _local;
  final IncomeRemoteDatasource _remote;
  final String Function() _ownerId;

  IncomeRepositoryImpl({
    required IncomeLocalDatasource local,
    required IncomeRemoteDatasource remote,
    required String Function() ownerId,
  })  : _local = local,
        _remote = remote,
        _ownerId = ownerId;

  @override
  Future<Result<void>> deleteIncome(String id) async{
    try {
      await _local.deleteIncome(id);
      unawaited(_remote.deleteIncome(id).catchError((_) {}));
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<IncomeEntity?> getIncomeItem(String id) => _local.getIncome(id);

  @override
  Future<Result<void>> pullAll() async{
    try {
      final ownerId = _ownerId();
      final remoteIncome = await _remote.fetchIncome(ownerId);
      await _local.pullAll(ownerId, remoteIncome);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<IncomeEntity>> saveIncome({String? id, required String name}) async{
    try {
      final ownerId = _ownerId();

      final entity = await _local.upsertIncome(
        id: id,
        ownerId: ownerId,
        name: name,
      );

      unawaited(_pushOne(ownerId, entity));

      return Success(entity);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> syncPending() async{
    final ownerId = _ownerId();
    final pending = await _local.getUnsynced(ownerId);
    for (final entity in pending) {
      await _pushOne(ownerId, entity);
    }
  }

  @override
  Stream<List<IncomeEntity>> watchIncomeItem()  => _local.watchIncome(_ownerId());

  Future<void> _pushOne(String ownerId, IncomeEntity entity) async {
    try {
      await _remote.pushIncome(
        ownerId,
        IncomeModel(
          id: entity.id,
          name: entity.name,
        ),
      );
      await _local.markSynced(entity.id);
    } catch (_) {

    }
  }
}
