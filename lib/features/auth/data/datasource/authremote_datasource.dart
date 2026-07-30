import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _usersCollection = 'users';

  Stream<UserModel?> watchAuthState() {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _fetchUserDocument(user.uid, fallbackEmail: user.email ?? '');
    });
  }

  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(uid: user.uid, email: user.email ?? '', username: '');
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw const AuthException('Sign in failed. Please try again.');
      }

      return _fetchUserDocument(uid, fallbackEmail: email);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException on signIn: code=${e.code}, message=${e.message}');
      throw AuthException(_mapAuthErrorCode(e.code));
    }
  }

  Future<UserModel> signUp({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        throw const AuthException('Sign up failed. Please try again.');
      }

      final userModel = UserModel(
        uid: uid,
        email: email,
        username: username,
        phoneNumber: phoneNumber,
      );

      try {
        await _firestore
            .collection(_usersCollection)
            .doc(uid)
            .set(userModel.toMap())
            .timeout(const Duration(seconds: 10));
      } catch (e) {
        // ignore: avoid_print
        print('Firestore write failed on signUp: $e');
        try {
          await credential.user?.delete();
        } catch (deleteError) {
          // ignore: avoid_print
          print('Rollback delete failed: $deleteError');
        }
        throw const ServerException(
          'Could not save your profile. Please try again.',
        );
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('FirebaseAuthException on signUp: code=${e.code}, message=${e.message}');
      throw AuthException(_mapAuthErrorCode(e.code));
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel> _fetchUserDocument(
    String uid, {
    required String fallbackEmail,
  }) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 10));

      if (!doc.exists || doc.data() == null) {
        return UserModel(uid: uid, email: fallbackEmail, username: '');
      }

      return UserModel.fromMap(doc.data()!, uid);
    } catch (e) {
      // ignore: avoid_print
      print('Firestore read failed in _fetchUserDocument: $e');
      throw const ServerException('Could not load your profile.');
    }
  }

  String _mapAuthErrorCode(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'No internet connection';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled for this project';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Authentication failed ($code). Please try again';
    }
  }
}