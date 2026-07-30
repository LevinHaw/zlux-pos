import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';

class IncomeModel extends IncomeEntity {
  const IncomeModel({
    required super.id,
    required super.name,
  });

  factory IncomeModel.fromFirestore(String id, Map<String, dynamic> map) {
    return IncomeModel(
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
