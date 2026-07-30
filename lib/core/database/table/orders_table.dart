import 'package:drift/drift.dart';

class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  RealColumn get total => real()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get paymentMethod =>
      text().withDefault(const Constant('cash'))();

  @override
  Set<Column> get primaryKey => {id};
}
