import 'package:zlux_pos/features/auth/data/datasource/authremote_datasource.dart';
import 'package:zlux_pos/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> watchAuthState() {
    return _remoteDataSource.watchAuthState();
  }

  @override
  UserEntity? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Result.success(user);
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (_) {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<UserEntity>> signUp({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signUp(
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      return Result.success(user);
    } on AuthException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (_) {
      return const Result.failure(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Result.success(null);
    } catch (_) {
      return const Result.failure(UnknownFailure());
    }
  }
}