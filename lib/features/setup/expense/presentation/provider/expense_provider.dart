import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/provider/database_provider.dart';
import '../../data/datasource/expense_local_datasource.dart';
import '../../data/datasource/expense_remote_datasource.dart';
import '../../data/repository/expense_repository_impl.dart';
import '../../domain/repository/expense_repository.dart';
import '../../domain/usecase/delete_expense_usecase.dart';
import '../../domain/usecase/pull_expense_usecase.dart';
import '../../domain/usecase/save_expense_usecase.dart';
import '../../domain/usecase/watch_expense_usecase.dart';

part 'expense_provider.g.dart';

String _requireUid() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw StateError('User is not authenticated');
  return user.uid;
}

@riverpod
ExpenseLocalDatasource expenseLocalDataSource(ExpenseLocalDataSourceRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ExpenseLocalDatasource(db.expenseDao);
}

@riverpod
ExpenseRemoteDatasource expenseRemoteDataSource(ExpenseRemoteDataSourceRef ref) {
  return ExpenseRemoteDatasource(FirebaseFirestore.instance);
}

@riverpod
ExpenseRepository expenseRepository(ExpenseRepositoryRef ref) {
  return ExpenseRepositoryImpl(
    local: ref.watch(expenseLocalDataSourceProvider),
    remote: ref.watch(expenseRemoteDataSourceProvider),
    ownerId: _requireUid,
  );
}

@riverpod
DeleteExpenseUsecase deleteExpenseUsecase(DeleteExpenseUsecaseRef ref) {
  return DeleteExpenseUsecase(ref.watch(expenseRepositoryProvider));
}

@riverpod
PullExpenseUsecase pullExpenseUsecase(PullExpenseUsecaseRef ref) {
  return PullExpenseUsecase(ref.watch(expenseRepositoryProvider));
}

@riverpod
SaveExpenseUsecase saveExpenseUsecase(SaveExpenseUsecaseRef ref) {
  return SaveExpenseUsecase(ref.watch(expenseRepositoryProvider));
}

@riverpod
WatchExpenseUsecase watchExpenseUsecase(WatchExpenseUsecaseRef ref) {
  return WatchExpenseUsecase(ref.watch(expenseRepositoryProvider));
}