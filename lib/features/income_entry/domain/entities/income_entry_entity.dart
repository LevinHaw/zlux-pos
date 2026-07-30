class IncomeEntryEntity {
  final String id;
  final String incomeId;
  final String incomeName;
  final double amount;
  final String note;
  final DateTime date;

  const IncomeEntryEntity({
    required this.id,
    required this.incomeId,
    required this.incomeName,
    required this.amount,
    this.note = '',
    required this.date,
  });

  IncomeEntryEntity copyWith({
    String? id,
    String? incomeId,
    String? incomeName,
    double? amount,
    String? note,
    DateTime? date,
  }) {
    return IncomeEntryEntity(
      id: id ?? this.id,
      incomeId: incomeId ?? this.incomeId,
      incomeName: incomeName ?? this.incomeName,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}
