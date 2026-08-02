import 'package:zlux_pos/features/report/domain/repository/daily_report_note_repository.dart';

class PullDailyReportNotesUsecase {
  final DailyReportNoteRepository _repository;

  const PullDailyReportNotesUsecase(this._repository);

  Future<void> call() => _repository.pullAll();
}
