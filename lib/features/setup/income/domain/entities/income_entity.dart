class IncomeEntity {
  final String id;
  final String name;

  const IncomeEntity({
    required this.id,
    required this.name,
  });

  IncomeEntity copyWith({
    String? id,
    String? name,
  }) {
    return IncomeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
