import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';


abstract class AuthRepository {
  Stream<UserEntity?> watchAuthState();

  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> signUp({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  });

  Future<Result<void>> signOut();

  UserEntity? get currentUser;
}