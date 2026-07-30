import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';

class ExpenseEntryModel extends ExpenseEntryEntity {
  const ExpenseEntryModel({
    required super.id,
    required super.expenseId,
    required super.expenseName,
    required super.amount,
    super.note,
    required super.date,
  });

  factory ExpenseEntryModel.fromFirestore(String id, Map<String, dynamic> map) {
    final rawDate = map['date'];
    return ExpenseEntryModel(
      id: id,
      expenseId: map['expenseId'] as String? ?? '',
      expenseName: map['expenseName'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      note: map['note'] as String? ?? '',
      date: rawDate is Timestamp ? rawDate.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestoreMap(String ownerId) {
    return {
      'ownerId': ownerId,
      'expenseId': expenseId,
      'expenseName': expenseName,
      'amount': amount,
      'note': note,
      'date': Timestamp.fromDate(date),
    };
  }
}
