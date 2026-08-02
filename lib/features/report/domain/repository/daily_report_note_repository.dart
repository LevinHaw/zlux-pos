import '../entities/daily_report_note_entity.dart';

abstract class DailyReportNoteRepository {
  Stream<DailyReportNoteEntity?> watchNoteByDate(DateTime date);

  Future<DailyReportNoteEntity> saveNote({
    required DateTime date,
    required String note,
  });

  Future<void> syncPending();

  Future<void> pullAll();
}
