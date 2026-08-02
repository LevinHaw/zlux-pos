import 'package:zlux_pos/features/report/domain/entities/daily_report_note_entity.dart';
import 'package:zlux_pos/features/report/domain/repository/daily_report_note_repository.dart';

class SaveDailyReportNoteUsecase {
  final DailyReportNoteRepository _repository;

  const SaveDailyReportNoteUsecase(this._repository);

  Future<DailyReportNoteEntity> call({
    required DateTime date,
    required String note,
  }) {
    return _repository.saveNote(date: date, note: note);
  }
}
