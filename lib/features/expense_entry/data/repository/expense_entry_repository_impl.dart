import 'dart:async';

import 'package:zlux_pos/core/error/failures.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/expense_entry/data/datasource/expense_entry_local_datasource.dart';
import 'package:zlux_pos/features/expense_entry/data/datasource/expense_entry_remote_datasource.dart';
import 'package:zlux_pos/features/expense_entry/data/models/expense_entry_model.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/expense_entry/domain/repository/expense_entry_repository.dart';

class ExpenseEntryRepositoryImpl implements ExpenseEntryRepository {
  final ExpenseEntryLocalDatasource _local;
  final ExpenseEntryRemoteDatasource _remote;
  final String Function() _ownerId;

  ExpenseEntryRepositoryImpl({
    required ExpenseEntryLocalDatasource local,
    required ExpenseEntryRemoteDatasource remote,
    required String Function() ownerId,
  })  : _local = local,
        _remote = remote,
        _ownerId = ownerId;

  @override
  Future<Result<void>> deleteExpenseEntry(String id) async {
    try {
      await _local.deleteExpenseEntry(id);
      unawaited(_remote.deleteExpenseEntry(id).catchError((_) {}));
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ExpenseEntryEntity?> getExpenseEntry(String id) =>
      _local.getExpenseEntry(id);

  @override
  Future<Result<void>> pullAll() async {
    try {
      final ownerId = _ownerId();
      final remoteEntries = await _remote.fetchExpenseEntries(ownerId);
      await _local.pullAll(ownerId, remoteEntries);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ExpenseEntryEntity>> saveExpenseEntry({
    String? id,
    required String expenseId,
    required String expenseName,
    required double amount,
    String note = '',
    required DateTime date,
  }) async {
    try {
      final ownerId = _ownerId();

      final entity = await _local.upsertExpenseEntry(
        id: id,
        ownerId: ownerId,
        expenseId: expenseId,
        expenseName: expenseName,
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
  Stream<List<ExpenseEntryEntity>> watchExpenseEntries() =>
      _local.watchExpenseEntries(_ownerId());

  Future<void> _pushOne(String ownerId, ExpenseEntryEntity entity) async {
    try {
      await _remote.pushExpenseEntry(
        ownerId,
        ExpenseEntryModel(
          id: entity.id,
          expenseId: entity.expenseId,
          expenseName: entity.expenseName,
          amount: entity.amount,
          note: entity.note,
          date: entity.date,
        ),
      );
      await _local.markSynced(entity.id);
    } catch (_) {}
  }
}
