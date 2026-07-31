import '../../../expense_entry/domain/entities/expense_entry_entity.dart';
import '../../../income_entry/domain/entities/income_entry_entity.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../entities/daily_report_entity.dart';

class ComputeDailyReportUsecase {
  const ComputeDailyReportUsecase();

  DailyReportEntity call({
    required DateTime date,
    required List<OrderEntity> orders,
    required List<IncomeEntryEntity> incomeEntries,
    required List<ExpenseEntryEntity> expenseEntries,
  }) {
    final transactionIncome = orders.fold<double>(
      0,
      (sum, order) => sum + order.total,
    );
    final incomeEntryAmount = incomeEntries.fold<double>(
      0,
      (sum, entry) => sum + entry.amount,
    );
    final totalExpense = expenseEntries.fold<double>(
      0,
      (sum, entry) => sum + entry.amount,
    );
    final totalIncome = transactionIncome + incomeEntryAmount;

    return DailyReportEntity(
      date: date,
      totalTransactions: orders.length,
      transactionIncome: transactionIncome,
      incomeEntryAmount: incomeEntryAmount,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      profit: totalIncome - totalExpense,
    );
  }
}
