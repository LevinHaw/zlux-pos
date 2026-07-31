import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/provider/database_provider.dart';
import 'package:zlux_pos/features/income_entry/data/datasource/income_entry_local_datasource.dart';
import 'package:zlux_pos/features/income_entry/data/datasource/income_entry_remote_datasource.dart';
import 'package:zlux_pos/features/income_entry/data/repository/income_entry_repository_impl.dart';
import 'package:zlux_pos/features/income_entry/domain/repository/income_entry_repository.dart';
import 'package:zlux_pos/features/income_entry/domain/usecase/delete_income_entry_usecase.dart';
import 'package:zlux_pos/features/income_entry/domain/usecase/pull_income_entries_usecase.dart';
import 'package:zlux_pos/features/income_entry/domain/usecase/save_income_entry_usecase.dart';
import 'package:zlux_pos/features/income_entry/domain/usecase/watch_income_entries_usecase.dart';

import '../../domain/usecase/watch_income_dates_in_month_usecase.dart';
import '../../domain/usecase/watch_income_entries_by_date_usecase.dart';

part 'income_entry_provider.g.dart';

String _requireUid() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw StateError('User is not authenticated');
  return user.uid;
}

@riverpod
IncomeEntryLocalDatasource incomeEntryLocalDataSource(
  IncomeEntryLocalDataSourceRef ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return IncomeEntryLocalDatasource(db.incomeEntryDao);
}

@riverpod
IncomeEntryRemoteDatasource incomeEntryRemoteDataSource(
  IncomeEntryRemoteDataSourceRef ref,
) {
  return IncomeEntryRemoteDatasource(FirebaseFirestore.instance);
}

@riverpod
IncomeEntryRepository incomeEntryRepository(IncomeEntryRepositoryRef ref) {
  return IncomeEntryRepositoryImpl(
    local: ref.watch(incomeEntryLocalDataSourceProvider),
    remote: ref.watch(incomeEntryRemoteDataSourceProvider),
    ownerId: _requireUid,
  );
}

@riverpod
DeleteIncomeEntryUsecase deleteIncomeEntryUsecase(
  DeleteIncomeEntryUsecaseRef ref,
) {
  return DeleteIncomeEntryUsecase(ref.watch(incomeEntryRepositoryProvider));
}

@riverpod
PullIncomeEntriesUsecase pullIncomeEntriesUsecase(
  PullIncomeEntriesUsecaseRef ref,
) {
  return PullIncomeEntriesUsecase(ref.watch(incomeEntryRepositoryProvider));
}

@riverpod
SaveIncomeEntryUsecase saveIncomeEntryUsecase(
  SaveIncomeEntryUsecaseRef ref,
) {
  return SaveIncomeEntryUsecase(ref.watch(incomeEntryRepositoryProvider));
}

@riverpod
WatchIncomeEntriesUsecase watchIncomeEntriesUsecase(
  WatchIncomeEntriesUsecaseRef ref,
) {
  return WatchIncomeEntriesUsecase(ref.watch(incomeEntryRepositoryProvider));
}

@riverpod
WatchIncomeEntriesByDateUsecase watchIncomeEntriesByDateUsecase(
  WatchIncomeEntriesByDateUsecaseRef ref,
) {
  return WatchIncomeEntriesByDateUsecase(
    ref.watch(incomeEntryRepositoryProvider),
  );
}

@riverpod
WatchIncomeDatesInMonthUsecase watchIncomeDatesInMonthUsecase(
  WatchIncomeDatesInMonthUsecaseRef ref,
) {
  return WatchIncomeDatesInMonthUsecase(
    ref.watch(incomeEntryRepositoryProvider),
  );
}
