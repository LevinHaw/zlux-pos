  class DailyReportEntity {
  final DateTime date;
  final int totalTransactions;
  final double transactionIncome;
  final double incomeEntryAmount;
  final double totalIncome;
  final double totalExpense;
  final double profit;

  const DailyReportEntity({
    required this.date,
    required this.totalTransactions,
    required this.transactionIncome,
    required this.incomeEntryAmount,
    required this.totalIncome,
    required this.totalExpense,
    required this.profit,
  });

  factory DailyReportEntity.empty(DateTime date) => DailyReportEntity(
        date: date,
        totalTransactions: 0,
        transactionIncome: 0,
        incomeEntryAmount: 0,
        totalIncome: 0,
        totalExpense: 0,
        profit: 0,
      );
}
