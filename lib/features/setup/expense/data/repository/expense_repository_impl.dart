import 'dart:async';

import 'package:zlux_pos/features/setup/expense/data/models/expense_model.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repository/expense_repository.dart';
import '../datasource/expense_local_datasource.dart';
import '../datasource/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource _local;
  final ExpenseRemoteDatasource _remote;
  final String Function() _ownerId;

  ExpenseRepositoryImpl({
    required ExpenseLocalDatasource local,
    required ExpenseRemoteDatasource remote,
    required String Function() ownerId,
  })  : _local = local,
        _remote = remote,
        _ownerId = ownerId;

  @override
  Future<Result<void>> deleteExpense(String id) async{
    try {
      await _local.deleteExpense(id);
      unawaited(_remote.deleteExpense(id).catchError((_) {}));
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ExpenseEntity?> getExpenseItem(String id) => _local.getExpense(id);

  @override
  Future<Result<void>> pullAll() async{
    try {
      final ownerId = _ownerId();
      final remoteExpense = await _remote.fetchExpense(ownerId);
      await _local.pullAll(ownerId, remoteExpense);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ExpenseEntity>> saveExpense({String? id, required String name}) async{
    try {
      final ownerId = _ownerId();

      final entity = await _local.upsertExpense(
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
  Stream<List<ExpenseEntity>> watchExpenseItem()  => _local.watchExpense(_ownerId());

  Future<void> _pushOne(String ownerId, ExpenseEntity entity) async {
    try {
      await _remote.pushExpense(
        ownerId,
        ExpenseModel(
          id: entity.id,
          name: entity.name,
        ),
      );
      await _local.markSynced(entity.id);
    } catch (_) {

    }
  }
}