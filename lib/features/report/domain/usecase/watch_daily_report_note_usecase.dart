import 'package:zlux_pos/features/report/domain/entities/daily_report_note_entity.dart';
import 'package:zlux_pos/features/report/domain/repository/daily_report_note_repository.dart';

class WatchDailyReportNoteUsecase {
  final DailyReportNoteRepository _repository;

  const WatchDailyReportNoteUsecase(this._repository);

  Stream<DailyReportNoteEntity?> call(DateTime date) =>
      _repository.watchNoteByDate(date);
}
