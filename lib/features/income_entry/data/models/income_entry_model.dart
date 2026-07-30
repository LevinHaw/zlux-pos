import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/income_entry/domain/entities/income_entry_entity.dart';

class IncomeEntryModel extends IncomeEntryEntity {
  const IncomeEntryModel({
    required super.id,
    required super.incomeId,
    required super.incomeName,
    required super.amount,
    super.note,
    required super.date,
  });

  factory IncomeEntryModel.fromFirestore(String id, Map<String, dynamic> map) {
    final rawDate = map['date'];
    return IncomeEntryModel(
      id: id,
      incomeId: map['incomeId'] as String? ?? '',
      incomeName: map['incomeName'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      note: map['note'] as String? ?? '',
      date: rawDate is Timestamp ? rawDate.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestoreMap(String ownerId) {
    return {
      'ownerId': ownerId,
      'incomeId': incomeId,
      'incomeName': incomeName,
      'amount': amount,
      'note': note,
      'date': Timestamp.fromDate(date),
    };
  }
}
