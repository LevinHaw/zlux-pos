import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/expense_entry/data/models/expense_entry_model.dart';

class ExpenseEntryRemoteDatasource {
  final FirebaseFirestore _firestore;

  ExpenseEntryRemoteDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('expense_entries');

  Future<void> pushExpenseEntry(String ownerId, ExpenseEntryModel model) {
    return _collection.doc(model.id).set(model.toFirestoreMap(ownerId));
  }

  Future<void> deleteExpenseEntry(String id) {
    return _collection.doc(id).delete();
  }

  Future<List<ExpenseEntryModel>> fetchExpenseEntries(String ownerId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs
        .map((doc) => ExpenseEntryModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
