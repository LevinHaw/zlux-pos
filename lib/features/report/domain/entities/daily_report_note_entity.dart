class DailyReportNoteEntity {
  final String id;
  final DateTime date;
  final String note;
  final DateTime updatedAt;

  const DailyReportNoteEntity({
    required this.id,
    required this.date,
    required this.note,
    required this.updatedAt,
  });

  factory DailyReportNoteEntity.empty(DateTime date) => DailyReportNoteEntity(
        id: '',
        date: date,
        note: '',
        updatedAt: date,
      );
}
