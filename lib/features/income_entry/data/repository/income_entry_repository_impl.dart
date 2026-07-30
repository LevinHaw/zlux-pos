import 'dart:async';

import 'package:zlux_pos/core/error/failures.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/income_entry/data/datasource/income_entry_local_datasource.dart';
import 'package:zlux_pos/features/income_entry/data/datasource/income_entry_remote_datasource.dart';
import 'package:zlux_pos/features/income_entry/data/models/income_entry_model.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';
import 'package:zlux_pos/features/income_entry/domain/repository/income_entry_repository.dart';

class IncomeEntryRepositoryImpl implements IncomeEntryRepository {
  final IncomeEntryLocalDatasource _local;
  final IncomeEntryRemoteDatasource _remote;
  final String Function() _ownerId;

  IncomeEntryRepositoryImpl({
    required IncomeEntryLocalDatasource local,
    required IncomeEntryRemoteDatasource remote,
    required String Function() ownerId,
  })  : _local = local,
        _remote = remote,
        _ownerId = ownerId;

  @override
  Future<Result<void>> deleteIncomeEntry(String id) async {
    try {
      await _local.deleteIncomeEntry(id);
      unawaited(_remote.deleteIncomeEntry(id).catchError((_) {}));
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<IncomeEntryEntity?> getIncomeEntry(String id) =>
      _local.getIncomeEntry(id);

  @override
  Future<Result<void>> pullAll() async {
    try {
      final ownerId = _ownerId();
      final remoteEntries = await _remote.fetchIncomeEntries(ownerId);
      await _local.pullAll(ownerId, remoteEntries);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<IncomeEntryEntity>> saveIncomeEntry({
    String? id,
    required String incomeId,
    required String incomeName,
    required double amount,
    String note = '',
    required DateTime date,
  }) async {
    try {
      final ownerId = _ownerId();

      final entity = await _local.upsertIncomeEntry(
        id: id,
        ownerId: ownerId,
        incomeId: incomeId,
        incomeName: incomeName,
        amount: amount,
        note: note,
        date: date,
      );

      unawaited(_pushOne(ownerId, entity));

      return Success(entity);
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
  Stream<List<IncomeEntryEntity>> watchIncomeEntries() =>
      _local.watchIncomeEntries(_ownerId());

  Future<void> _pushOne(String ownerId, IncomeEntryEntity entity) async {
    try {
      await _remote.pushIncomeEntry(
        ownerId,
        IncomeEntryModel(
          id: entity.id,
          incomeId: entity.incomeId,
          incomeName: entity.incomeName,
          amount: entity.amount,
          note: entity.note,
          date: entity.date,
        ),
      );
      await _local.markSynced(entity.id);
    } catch (_) {}
  }
}
