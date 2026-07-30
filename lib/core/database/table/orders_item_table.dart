import 'package:drift/drift.dart';

class OrderItems extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text()();
  TextColumn get productId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  IntColumn get quantity => integer()();
  RealColumn get price => real()();

  @override
  Set<Column> get primaryKey => {id};
}
