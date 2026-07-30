class ExpenseEntryEntity {
  final String id;
  final String expenseId;
  final String expenseName;
  final double amount;
  final String note;
  final DateTime date;

  const ExpenseEntryEntity({
    required this.id,
    required this.expenseId,
    required this.expenseName,
    required this.amount,
    this.note = '',
    required this.date,
  });

  ExpenseEntryEntity copyWith({
    String? id,
    String? expenseId,
    String? expenseName,
    double? amount,
    String? note,
    DateTime? date,
  }) {
    return ExpenseEntryEntity(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      expenseName: expenseName ?? this.expenseName,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}
