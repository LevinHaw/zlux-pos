import 'package:drift/drift.dart';

class Income extends Table{
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get name => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}