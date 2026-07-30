import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/provider/database_provider.dart';
import 'package:zlux_pos/features/setup/income/data/datasource/income_local_datasource.dart';
import 'package:zlux_pos/features/setup/income/data/datasource/income_remote_datasource.dart';
import 'package:zlux_pos/features/setup/income/data/repository/income_repository_impl.dart';
import 'package:zlux_pos/features/setup/income/domain/repository/income_repository.dart';
import 'package:zlux_pos/features/setup/income/domain/usecase/delete_income_usecase.dart';
import 'package:zlux_pos/features/setup/income/domain/usecase/pull_income_usecase.dart';
import 'package:zlux_pos/features/setup/income/domain/usecase/save_income_usecase.dart';
import 'package:zlux_pos/features/setup/income/domain/usecase/watch_income_usecase.dart';

part 'income_provider.g.dart';

String _requireUid() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw StateError('User is not authenticated');
  return user.uid;
}

@riverpod
IncomeLocalDatasource incomeLocalDataSource(IncomeLocalDataSourceRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return IncomeLocalDatasource(db.incomeDao);
}

@riverpod
IncomeRemoteDatasource incomeRemoteDataSource(IncomeRemoteDataSourceRef ref) {
  return IncomeRemoteDatasource(FirebaseFirestore.instance);
}

@riverpod
IncomeRepository incomeRepository(IncomeRepositoryRef ref) {
  return IncomeRepositoryImpl(
    local: ref.watch(incomeLocalDataSourceProvider),
    remote: ref.watch(incomeRemoteDataSourceProvider),
    ownerId: _requireUid,
  );
}

@riverpod
DeleteIncomeUsecase deleteIncomeUsecase(DeleteIncomeUsecaseRef ref) {
  return DeleteIncomeUsecase(ref.watch(incomeRepositoryProvider));
}

@riverpod
PullIncomeUsecase pullIncomeUsecase(PullIncomeUsecaseRef ref) {
  return PullIncomeUsecase(ref.watch(incomeRepositoryProvider));
}

@riverpod
SaveIncomeUsecase saveIncomeUsecase(SaveIncomeUsecaseRef ref) {
  return SaveIncomeUsecase(ref.watch(incomeRepositoryProvider));
}

@riverpod
WatchIncomeUsecase watchIncomeUsecase(WatchIncomeUsecaseRef ref) {
  return WatchIncomeUsecase(ref.watch(incomeRepositoryProvider));
}
