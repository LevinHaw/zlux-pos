import 'package:drift/drift.dart';

@DataClassName('ExpenseEntryData')
class ExpenseEntries extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get expenseId => text()();
  TextColumn get expenseName => text()();
  RealColumn get amount => real()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
