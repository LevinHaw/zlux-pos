import 'package:zlux_pos/core/utils/combine_latest.dart';
import 'package:zlux_pos/features/expense_entry/domain/usecase/watch_expense_dates_in_month_usecase.dart';
import 'package:zlux_pos/features/income_entry/domain/usecase/watch_income_dates_in_month_usecase.dart';

import '../../../order/domain/usecase/watch_order_by_date_usecase.dart';

/// Merges the days that have at least one order, income entry, or expense
/// entry for the given month into a single, distinct, ascending list of
/// dates — used to populate the daily report list.
class WatchReportDatesUsecase {
  final WatchOrderDateMonthUsecase _watchOrderDates;
  final WatchIncomeDatesInMonthUsecase _watchIncomeDates;
  final WatchExpenseDatesInMonthUsecase _watchExpenseDates;

  const WatchReportDatesUsecase({
    required WatchOrderDateMonthUsecase watchOrderDates,
    required WatchIncomeDatesInMonthUsecase watchIncomeDates,
    required WatchExpenseDatesInMonthUsecase watchExpenseDates,
  })  : _watchOrderDates = watchOrderDates,
        _watchIncomeDates = watchIncomeDates,
        _watchExpenseDates = watchExpenseDates;

  Stream<List<DateTime>> call({required int year, required int month}) {
    return combineLatest3<List<DateTime>, List<DateTime>, List<DateTime>,
        List<DateTime>>(
      _watchOrderDates(year: year, month: month),
      _watchIncomeDates(year: year, month: month),
      _watchExpenseDates(year: year, month: month),
      (orderDates, incomeDates, expenseDates) {
        final merged = <DateTime>{...orderDates, ...incomeDates, ...expenseDates}
            .toList();
        merged.sort((a, b) => a.compareTo(b));
        return merged;
      },
    );
  }
}
