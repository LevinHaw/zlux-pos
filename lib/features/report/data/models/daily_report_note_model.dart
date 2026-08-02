import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/report/domain/entities/daily_report_note_entity.dart';

class DailyReportNoteModel extends DailyReportNoteEntity {
  const DailyReportNoteModel({
    required super.id,
    required super.date,
    required super.note,
    required super.updatedAt,
  });

  factory DailyReportNoteModel.fromFirestore(
    String id,
    Map<String, dynamic> map,
  ) {
    final rawDate = map['date'];
    final rawUpdatedAt = map['updatedAt'];
    return DailyReportNoteModel(
      id: id,
      date: rawDate is Timestamp ? rawDate.toDate() : DateTime.now(),
      note: map['note'] as String? ?? '',
      updatedAt:
          rawUpdatedAt is Timestamp ? rawUpdatedAt.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestoreMap(String ownerId) {
    return {
      'ownerId': ownerId,
      'date': Timestamp.fromDate(date),
      'note': note,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
