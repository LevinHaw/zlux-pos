import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/income_entry/data/models/income_entry_model.dart';

class IncomeEntryRemoteDatasource {
  final FirebaseFirestore _firestore;

  IncomeEntryRemoteDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('income_entries');

  Future<void> pushIncomeEntry(String ownerId, IncomeEntryModel model) {
    return _collection.doc(model.id).set(model.toFirestoreMap(ownerId));
  }

  Future<void> deleteIncomeEntry(String id) {
    return _collection.doc(id).delete();
  }

  Future<List<IncomeEntryModel>> fetchIncomeEntries(String ownerId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs
        .map((doc) => IncomeEntryModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
