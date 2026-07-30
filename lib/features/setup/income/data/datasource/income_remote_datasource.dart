import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/setup/income/data/models/income_model.dart';

class IncomeRemoteDatasource {
  final FirebaseFirestore _firestore;

  IncomeRemoteDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('income');

  Future<void> pushIncome(String ownerId, IncomeModel model) {
    return _collection.doc(model.id).set(model.toFirestoreMap(ownerId));
  }

  Future<void> deleteIncome(String id) {
    return _collection.doc(id).delete();
  }

  Future<List<IncomeModel>> fetchIncome(String ownerId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs
        .map((doc) => IncomeModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
