import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/pdf/daily_report_pdf_service.dart';
import 'package:zlux_pos/features/expense_entry/presentation/provider/expense_entry_provider.dart';
import 'package:zlux_pos/features/income_entry/presentation/provider/income_entry_provider.dart';
import 'package:zlux_pos/features/order/presentation/order_provider.dart';
import 'package:zlux_pos/features/report/domain/entities/daily_report_detail_entity.dart';
import 'package:zlux_pos/features/report/domain/usecase/compute_daily_report_detail_usecase.dart';
import 'package:zlux_pos/features/report/domain/usecase/watch_daily_report_detail_usecase.dart';
import 'package:zlux_pos/features/report/domain/usecase/watch_report_dates_usecase.dart';

part 'report_provider.g.dart';

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
