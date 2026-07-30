class ExpenseEntity {
  final String id;
  final String name;

  const ExpenseEntity({
    required this.id,
    required this.name,
  });

  ExpenseEntity copyWith({
    String? id,
    String? name,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}