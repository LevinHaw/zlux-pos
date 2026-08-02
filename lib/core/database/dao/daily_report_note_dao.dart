import 'package:drift/drift.dart';

import '../app_database.dart';
import '../table/daily_report_notes_table.dart';

part 'daily_report_note_dao.g.dart';

@DriftAccessor(tables: [DailyReportNotes])
class DailyReportNoteDao extends DatabaseAccessor<AppDatabase>
    with _$DailyReportNoteDaoMixin {
  DailyReportNoteDao(super.db);

  Future<DailyReportNoteData?> getNote(String id) {
    return (select(dailyReportNotes)..where((n) => n.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<DailyReportNoteData?> watchNote(String id) {
    return (select(dailyReportNotes)..where((n) => n.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<void> upsertNote(DailyReportNotesCompanion note) {
    return into(dailyReportNotes).insertOnConflictUpdate(note);
  }

  Future<void> upsertAllNotes(List<DailyReportNotesCompanion> notes) {
    return batch((b) {
      b.insertAllOnConflictUpdate(dailyReportNotes, notes);
    });
  }

  Future<List<DailyReportNoteData>> getUnsyncedNotes(String ownerId) {
    return (select(dailyReportNotes)
          ..where(
            (n) => n.ownerId.equals(ownerId) & n.isSynced.equals(false),
          ))
        .get();
  }

  Future<void> markSynced(String id) {
    return (update(dailyReportNotes)..where((n) => n.id.equals(id)))
        .write(const DailyReportNotesCompanion(isSynced: Value(true)));
  }
}
