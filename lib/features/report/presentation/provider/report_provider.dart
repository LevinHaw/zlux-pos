import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/pdf/daily_report_pdf_service.dart';
import 'package:zlux_pos/core/provider/database_provider.dart';
import 'package:zlux_pos/features/expense_entry/presentation/provider/expense_entry_provider.dart';
import 'package:zlux_pos/features/income_entry/presentation/provider/income_entry_provider.dart';
import 'package:zlux_pos/features/order/presentation/order_provider.dart';
import 'package:zlux_pos/features/report/data/datasource/daily_report_note_local_datasource.dart';
import 'package:zlux_pos/features/report/data/datasource/daily_report_note_remote_datasource.dart';
import 'package:zlux_pos/features/report/domain/entities/daily_report_detail_entity.dart';
import 'package:zlux_pos/features/report/domain/entities/daily_report_note_entity.dart';
import 'package:zlux_pos/features/report/domain/repository/daily_report_note_repository.dart';
import 'package:zlux_pos/features/report/domain/usecase/compute_daily_report_detail_usecase.dart';
import 'package:zlux_pos/features/report/domain/usecase/pull_daily_report_notes_usecase.dart';
import 'package:zlux_pos/features/report/domain/usecase/save_daily_report_note_usecase.dart';
import 'package:zlux_pos/features/report/domain/usecase/watch_daily_report_detail_usecase.dart';
import 'package:zlux_pos/features/report/domain/usecase/watch_daily_report_note_usecase.dart';
import 'package:zlux_pos/features/report/domain/usecase/watch_report_dates_usecase.dart';

import '../../data/repository/daily_note_report_repository_impl.dart';

part 'report_provider.g.dart';

String _requireUid() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw StateError('User is not authenticated');
  return user.uid;
}

@riverpod
DailyReportPdfService dailyReportPdfService(DailyReportPdfServiceRef ref) {
  return const DailyReportPdfService();
}

@riverpod
ComputeDailyReportDetailUsecase computeDailyReportDetailUsecase(
  ComputeDailyReportDetailUsecaseRef ref,
) {
  return const ComputeDailyReportDetailUsecase();
}

@riverpod
WatchDailyReportDetailUsecase watchDailyReportDetailUsecase(
  WatchDailyReportDetailUsecaseRef ref,
) {
  return WatchDailyReportDetailUsecase(
    watchOrders: ref.watch(watchOrdersByDateUsecaseProvider),
    watchIncomeEntries: ref.watch(watchIncomeEntriesByDateUsecaseProvider),
    watchExpenseEntries: ref.watch(watchExpenseEntriesByDateUsecaseProvider),
    compute: ref.watch(computeDailyReportDetailUsecaseProvider),
  );
}

@riverpod
WatchReportDatesUsecase watchReportDatesUsecase(
  WatchReportDatesUsecaseRef ref,
) {
  return WatchReportDatesUsecase(
    watchOrderDates: ref.watch(watchOrderDateMonthUsecaseProvider),
    watchIncomeDates: ref.watch(watchIncomeDatesInMonthUsecaseProvider),
    watchExpenseDates: ref.watch(watchExpenseDatesInMonthUsecaseProvider),
  );
}

@riverpod
Stream<List<DateTime>> reportDates(
  ReportDatesRef ref, {
  required int year,
  required int month,
}) {
  final usecase = ref.watch(watchReportDatesUsecaseProvider);
  return usecase(year: year, month: month);
}

@riverpod
Stream<DailyReportDetailEntity> dailyReportDetail(
  DailyReportDetailRef ref,
  DateTime date,
) {
  final usecase = ref.watch(watchDailyReportDetailUsecaseProvider);
  return usecase(date);
}

@riverpod
DailyReportNoteLocalDatasource dailyReportNoteLocalDataSource(
  DailyReportNoteLocalDataSourceRef ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DailyReportNoteLocalDatasource(db.dailyReportNoteDao);
}

@riverpod
DailyReportNoteRemoteDatasource dailyReportNoteRemoteDataSource(
  DailyReportNoteRemoteDataSourceRef ref,
) {
  return DailyReportNoteRemoteDatasource(FirebaseFirestore.instance);
}

@riverpod
DailyReportNoteRepository dailyReportNoteRepository(
  DailyReportNoteRepositoryRef ref,
) {
  return DailyReportNoteRepositoryImpl(
    local: ref.watch(dailyReportNoteLocalDataSourceProvider),
    remote: ref.watch(dailyReportNoteRemoteDataSourceProvider),
    ownerId: _requireUid,
  );
}

@riverpod
SaveDailyReportNoteUsecase saveDailyReportNoteUsecase(
  SaveDailyReportNoteUsecaseRef ref,
) {
  return SaveDailyReportNoteUsecase(ref.watch(dailyReportNoteRepositoryProvider));
}

@riverpod
WatchDailyReportNoteUsecase watchDailyReportNoteUsecase(
  WatchDailyReportNoteUsecaseRef ref,
) {
  return WatchDailyReportNoteUsecase(
    ref.watch(dailyReportNoteRepositoryProvider),
  );
}

@riverpod
PullDailyReportNotesUsecase pullDailyReportNotesUsecase(
  PullDailyReportNotesUsecaseRef ref,
) {
  return PullDailyReportNotesUsecase(
    ref.watch(dailyReportNoteRepositoryProvider),
  );
}

@riverpod
Stream<DailyReportNoteEntity?> dailyReportNote(
  DailyReportNoteRef ref,
  DateTime date,
) {
  final usecase = ref.watch(watchDailyReportNoteUsecaseProvider);
  return usecase(date);
}
