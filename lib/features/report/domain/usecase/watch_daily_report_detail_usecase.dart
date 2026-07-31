import 'package:zlux_pos/core/utils/combine_latest.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/expense_entry/domain/usecase/watch_expense_entries_by_date_usecase.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';
import 'package:zlux_pos/features/income_entry/domain/usecase/watch_income_entries_by_date_usecase.dart';

import '../../../order/domain/entities/order_entity.dart';
import '../../../order/domain/usecase/watch_orderdate_month_usecase.dart';
import '../entities/daily_report_detail_entity.dart';
import 'compute_daily_report_detail_usecase.dart';

class WatchDailyReportDetailUsecase {
  final WatchOrdersByDateUsecase _watchOrders;
  final WatchIncomeEntriesByDateUsecase _watchIncomeEntries;
  final WatchExpenseEntriesByDateUsecase _watchExpenseEntries;
  final ComputeDailyReportDetailUsecase _compute;

  const WatchDailyReportDetailUsecase({
    required WatchOrdersByDateUsecase watchOrders,
    required WatchIncomeEntriesByDateUsecase watchIncomeEntries,
    required WatchExpenseEntriesByDateUsecase watchExpenseEntries,
    required ComputeDailyReportDetailUsecase compute,
  })  : _watchOrders = watchOrders,
        _watchIncomeEntries = watchIncomeEntries,
        _watchExpenseEntries = watchExpenseEntries,
        _compute = compute;

  Stream<DailyReportDetailEntity> call(DateTime date) {
    return combineLatest3<List<OrderEntity>, List<IncomeEntryEntity>,
        List<ExpenseEntryEntity>, DailyReportDetailEntity>(
      _watchOrders(date),
      _watchIncomeEntries(date),
      _watchExpenseEntries(date),
      (orders, incomeEntries, expenseEntries) => _compute(
        date: date,
        orders: orders,
        incomeEntries: incomeEntries,
        expenseEntries: expenseEntries,
      ),
    );
  }
}
