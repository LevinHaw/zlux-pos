import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/provider/database_provider.dart';
import 'package:zlux_pos/features/expense_entry/data/datasource/expense_entry_local_datasource.dart';
import 'package:zlux_pos/features/expense_entry/data/datasource/expense_entry_remote_datasource.dart';
import 'package:zlux_pos/features/expense_entry/data/repository/expense_entry_repository_impl.dart';
import 'package:zlux_pos/features/expense_entry/domain/repository/expense_entry_repository.dart';
import 'package:zlux_pos/features/expense_entry/domain/usecase/delete_expense_entry_usecase.dart';
import 'package:zlux_pos/features/expense_entry/domain/usecase/pull_expense_entries_usecase.dart';
import 'package:zlux_pos/features/expense_entry/domain/usecase/save_expense_entry_usecase.dart';
import 'package:zlux_pos/features/expense_entry/domain/usecase/watch_expense_entries_usecase.dart';

import '../../domain/usecase/watch_expense_dates_in_month_usecase.dart';
import '../../domain/usecase/watch_expense_entries_by_date_usecase.dart';

part 'expense_entry_provider.g.dart';

String _requireUid() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw StateError('User is not authenticated');
  return user.uid;
}

@riverpod
ExpenseEntryLocalDatasource expenseEntryLocalDataSource(
  ExpenseEntryLocalDataSourceRef ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return ExpenseEntryLocalDatasource(db.expenseEntryDao);
}

@riverpod
ExpenseEntryRemoteDatasource expenseEntryRemoteDataSource(
  ExpenseEntryRemoteDataSourceRef ref,
) {
  return ExpenseEntryRemoteDatasource(FirebaseFirestore.instance);
}

@riverpod
ExpenseEntryRepository expenseEntryRepository(ExpenseEntryRepositoryRef ref) {
  return ExpenseEntryRepositoryImpl(
    local: ref.watch(expenseEntryLocalDataSourceProvider),
    remote: ref.watch(expenseEntryRemoteDataSourceProvider),
    ownerId: _requireUid,
  );
}

@riverpod
DeleteExpenseEntryUsecase deleteExpenseEntryUsecase(
  DeleteExpenseEntryUsecaseRef ref,
) {
  return DeleteExpenseEntryUsecase(ref.watch(expenseEntryRepositoryProvider));
}

@riverpod
PullExpenseEntriesUsecase pullExpenseEntriesUsecase(
  PullExpenseEntriesUsecaseRef ref,
) {
  return PullExpenseEntriesUsecase(ref.watch(expenseEntryRepositoryProvider));
}

@riverpod
SaveExpenseEntryUsecase saveExpenseEntryUsecase(
  SaveExpenseEntryUsecaseRef ref,
) {
  return SaveExpenseEntryUsecase(ref.watch(expenseEntryRepositoryProvider));
}

@riverpod
WatchExpenseEntriesUsecase watchExpenseEntriesUsecase(
  WatchExpenseEntriesUsecaseRef ref,
) {
  return WatchExpenseEntriesUsecase(ref.watch(expenseEntryRepositoryProvider));
}

@riverpod
WatchExpenseEntriesByDateUsecase watchExpenseEntriesByDateUsecase(
  WatchExpenseEntriesByDateUsecaseRef ref,
) {
  return WatchExpenseEntriesByDateUsecase(
    ref.watch(expenseEntryRepositoryProvider),
  );
}

@riverpod
WatchExpenseDatesInMonthUsecase watchExpenseDatesInMonthUsecase(
  WatchExpenseDatesInMonthUsecaseRef ref,
) {
  return WatchExpenseDatesInMonthUsecase(
    ref.watch(expenseEntryRepositoryProvider),
  );
}
