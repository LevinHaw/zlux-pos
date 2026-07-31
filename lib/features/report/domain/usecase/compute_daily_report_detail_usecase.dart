import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';

import '../../../order/domain/entities/order_entity.dart';
import '../../../order/domain/entities/payment_method.dart';
import '../entities/daily_report_detail_entity.dart';
import '../entities/product_sale_summary_entity.dart';

class ComputeDailyReportDetailUsecase {
  const ComputeDailyReportDetailUsecase();

  DailyReportDetailEntity call({
    required DateTime date,
    required List<OrderEntity> orders,
    required List<IncomeEntryEntity> incomeEntries,
    required List<ExpenseEntryEntity> expenseEntries,
  }) {
    final productTotals = <String, ProductSaleSummaryEntity>{};
    var cashTotal = 0.0;
    var transferTotal = 0.0;
    var transactionIncome = 0.0;

    for (final order in orders) {
      transactionIncome += order.total;

      switch (order.paymentMethod) {
        case PaymentMethod.cash:
          cashTotal += order.total;
          break;
        case PaymentMethod.transfer:
          transferTotal += order.total;
          break;
      }

      for (final item in order.items) {
        final existing = productTotals[item.productId];
        productTotals[item.productId] = ProductSaleSummaryEntity(
          productId: item.productId,
          productName: item.name,
          quantity: (existing?.quantity ?? 0) + item.quantity,
          amount: (existing?.amount ?? 0) + item.subtotal,
        );
      }
    }

    final incomeEntryAmount = incomeEntries.fold<double>(
      0,
      (sum, entry) => sum + entry.amount,
    );
    final totalExpense = expenseEntries.fold<double>(
      0,
      (sum, entry) => sum + entry.amount,
    );
    final totalIncome = transactionIncome + incomeEntryAmount;

    return DailyReportDetailEntity(
      date: date,
      productSummaries: productTotals.values.toList(),
      totalTransactions: orders.length,
      transactionIncome: transactionIncome,
      cashTotal: cashTotal,
      transferTotal: transferTotal,
      incomeEntries: incomeEntries,
      incomeEntryAmount: incomeEntryAmount,
      expenseEntries: expenseEntries,
      totalExpense: totalExpense,
      totalIncome: totalIncome,
      profit: totalIncome - totalExpense,
    );
  }
}
