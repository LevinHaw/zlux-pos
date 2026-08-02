import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/report/data/models/daily_report_note_model.dart';

class DailyReportNoteRemoteDatasource {
  final FirebaseFirestore _firestore;

  DailyReportNoteRemoteDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('daily_report_notes');

  Future<void> pushNote(
    String id,
    String ownerId,
    DailyReportNoteModel model,
  ) {
    return _collection.doc(id).set(model.toFirestoreMap(ownerId));
  }

  Future<List<DailyReportNoteModel>> fetchNotes(String ownerId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs
        .map((doc) => DailyReportNoteModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
