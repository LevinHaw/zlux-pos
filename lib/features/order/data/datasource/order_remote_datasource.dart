import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zlux_pos/features/order/data/models/order_model.dart';


class OrderRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrderRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('orders');

  Future<void> pushOrder(String ownerId, OrderModel model) {
    return _collection.doc(model.id).set(model.toFirestoreMap(ownerId));
  }

   Future<void> deleteOrder(String orderId) {
    return _collection.doc(orderId).delete();
  }

  Future<List<OrderModel>> fetchOrders(String ownerId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs
        .map((doc) => OrderModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
