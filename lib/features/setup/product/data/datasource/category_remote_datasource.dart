import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  CategoryRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('categories');

  Future<void> pushCategory({
    required String id,
    required String ownerId,
    required String name,
  }) {
    return _collection.doc(id).set({
      'ownerId': ownerId,
      'name': name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<CategoryModel>> fetchCategories(String ownerId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: ownerId).get();

    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}