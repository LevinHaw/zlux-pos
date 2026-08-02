import 'package:drift/drift.dart';

@DataClassName('DailyReportNoteData')
class DailyReportNotes extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
