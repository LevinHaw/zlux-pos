import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zlux_pos/features/setup/data/models/merchant_model.dart';

import '../../../../core/error/exceptions.dart';

abstract class SetupRemoteDataSource {
  Future<MerchantModel> saveMerchant({
    required String name,
    required String address,
    File? imageFile,
  });

  Future<MerchantModel?> getMerchant();
}

class SetupRemoteDataSourceImpl implements SetupRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  SetupRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _auth = auth,
        _storage = storage;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException('User is not authenticated');
    }
    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _merchantDoc =>
      _firestore.collection('merchants').doc(_uid);

  @override
  Future<MerchantModel> saveMerchant({
    required String name,
    required String address,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        final ref = _storage.ref().child('merchants/$_uid/logo.jpg');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      final model = MerchantModel(
        id: _uid,
        name: name,
        address: address,
        imageUrl: imageUrl,
      );

      await _merchantDoc.set(model.toMap(), SetOptions(merge: true));

      final snapshot = await _merchantDoc.get();
      return MerchantModel.fromMap(_uid, snapshot.data() ?? {});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MerchantModel?> getMerchant() async {
    try {
      final snapshot = await _merchantDoc.get();
      if (!snapshot.exists) return null;
      return MerchantModel.fromMap(_uid, snapshot.data() ?? {});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
