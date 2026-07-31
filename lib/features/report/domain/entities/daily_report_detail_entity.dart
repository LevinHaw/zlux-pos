import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';

import 'product_sale_summary_entity.dart';

class DailyReportDetailEntity {
  final DateTime date;

  final List<ProductSaleSummaryEntity> productSummaries;
  final int totalTransactions;
  final double transactionIncome;

  final double cashTotal;
  final double transferTotal;

  final List<IncomeEntryEntity> incomeEntries;
  final double incomeEntryAmount;

  final List<ExpenseEntryEntity> expenseEntries;
  final double totalExpense;

  final double totalIncome;
  final double profit;

  const DailyReportDetailEntity({
    required this.date,
    required this.productSummaries,
    required this.totalTransactions,
    required this.transactionIncome,
    required this.cashTotal,
    required this.transferTotal,
    required this.incomeEntries,
    required this.incomeEntryAmount,
    required this.expenseEntries,
    required this.totalExpense,
    required this.totalIncome,
    required this.profit,
  });

  factory DailyReportDetailEntity.empty(DateTime date) =>
      DailyReportDetailEntity(
        date: date,
        productSummaries: const [],
        totalTransactions: 0,
        transactionIncome: 0,
        cashTotal: 0,
        transferTotal: 0,
        incomeEntries: const [],
        incomeEntryAmount: 0,
        expenseEntries: const [],
        totalExpense: 0,
        totalIncome: 0,
        profit: 0,
      );
}
