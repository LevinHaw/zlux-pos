import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/auth/data/datasource/authremote_datasource.dart';
import 'package:zlux_pos/features/auth/data/repository/auth_repository_impl.dart';
import 'package:zlux_pos/features/auth/domain/repository/auth_repository.dart';
import 'package:zlux_pos/features/auth/domain/usecase/signin_usecase.dart';
import 'package:zlux_pos/features/auth/domain/usecase/signout_usecase.dart';
import 'package:zlux_pos/features/auth/domain/usecase/signup_usecase.dart';
import 'package:zlux_pos/features/auth/domain/usecase/watch_authstate_usecase.dart';

import '../../domain/entities/user_entity.dart';
 
part 'auth_provider.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource();
}
 
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
}
 
@riverpod
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}
 
@riverpod
SignUpUseCase signUpUseCase(Ref ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
}
 
@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}
 
@riverpod
WatchAuthStateUseCase watchAuthStateUseCase(Ref ref) {
  return WatchAuthStateUseCase(ref.watch(authRepositoryProvider));
}
 
 
@riverpod
Stream<UserEntity?> authStateChanges(Ref ref) {
  return ref.watch(watchAuthStateUseCaseProvider).call();
}