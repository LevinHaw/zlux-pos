import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:zlux_pos/core/database/app_database.dart';
import 'package:zlux_pos/core/database/dao/daily_report_note_dao.dart';
import 'package:zlux_pos/features/report/data/models/daily_report_note_model.dart';
import 'package:zlux_pos/features/report/domain/entities/daily_report_note_entity.dart';

final _dateKeyFormat = DateFormat('yyyy-MM-dd');

String buildDailyReportNoteId(String ownerId, DateTime date) {
  return '${ownerId}_${_dateKeyFormat.format(date)}';
}

extension DailyReportNoteRowX on DailyReportNoteData {
  DailyReportNoteEntity toEntity() => DailyReportNoteEntity(
        id: id,
        date: date,
        note: note,
        updatedAt: updatedAt,
      );
}

class DailyReportNoteLocalDatasource {
  final DailyReportNoteDao _dao;

  DailyReportNoteLocalDatasource(this._dao);

  Stream<DailyReportNoteEntity?> watchNoteByDate(String ownerId, DateTime date) {
    final id = buildDailyReportNoteId(ownerId, date);
    return _dao.watchNote(id).map((row) => row?.toEntity());
  }

  Future<DailyReportNoteEntity> saveNote({
    required String ownerId,
    required DateTime date,
    required String note,
  }) async {
    final id = buildDailyReportNoteId(ownerId, date);
    final updatedAt = DateTime.now();

    await _dao.upsertNote(
      DailyReportNotesCompanion(
        id: Value(id),
        ownerId: Value(ownerId),
        date: Value(DateTime(date.year, date.month, date.day)),
        note: Value(note),
        updatedAt: Value(updatedAt),
        isSynced: const Value(false),
      ),
    );

    return DailyReportNoteEntity(
      id: id,
      date: date,
      note: note,
      updatedAt: updatedAt,
    );
  }

  Future<void> markSynced(String id) => _dao.markSynced(id);

  Future<List<DailyReportNoteEntity>> getUnsynced(String ownerId) async {
    final rows = await _dao.getUnsyncedNotes(ownerId);
    return rows.map((r) => r.toEntity()).toList();
  }

  Future<void> pullAll(String ownerId, List<DailyReportNoteModel> notes) {
    final companions = notes
        .map(
          (n) => DailyReportNotesCompanion(
            id: Value(n.id),
            ownerId: Value(ownerId),
            date: Value(DateTime(n.date.year, n.date.month, n.date.day)),
            note: Value(n.note),
            updatedAt: Value(n.updatedAt),
            isSynced: const Value(true),
          ),
        )
        .toList();

    return _dao.upsertAllNotes(companions);
  }
}
