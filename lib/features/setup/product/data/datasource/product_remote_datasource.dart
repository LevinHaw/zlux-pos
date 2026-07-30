import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('products');

  Future<void> pushProduct(String ownerId, ProductModel model) {
    return _collection.doc(model.id).set(model.toFirestoreMap(ownerId));
  }

  Future<void> deleteProduct(String id) {
    return _collection.doc(id).delete();
  }

  Future<List<ProductModel>> fetchProducts(String ownerId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}
