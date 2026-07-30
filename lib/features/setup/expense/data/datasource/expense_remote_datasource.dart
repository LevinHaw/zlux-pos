import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/setup/expense/data/models/expense_model.dart';

class ExpenseRemoteDatasource {
  final FirebaseFirestore _firestore;

  ExpenseRemoteDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('expense');

  Future<void> pushExpense(String ownerId, ExpenseModel model) {
    return _collection.doc(model.id).set(model.toFirestoreMap(ownerId));
  }

  Future<void> deleteExpense(String id) {
    return _collection.doc(id).delete();
  }

  Future<List<ExpenseModel>> fetchExpense(String ownerId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs
        .map((doc) => ExpenseModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}