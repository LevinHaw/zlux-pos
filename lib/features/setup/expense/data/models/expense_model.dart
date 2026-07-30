import 'package:zlux_pos/features/setup/expense/domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required String id,
    required String name,
  }) : super(id: id, name: name);

  factory ExpenseModel.fromFirestore(String id, Map<String, dynamic> map) {
    return ExpenseModel(
      id: id,
      name: map['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestoreMap(String ownerId) {
    return {
      'ownerId': ownerId,
      'name': name,
    };
  }
}