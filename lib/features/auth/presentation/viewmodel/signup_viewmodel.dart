import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/auth/domain/entities/user_entity.dart';
import 'package:zlux_pos/features/auth/presentation/provider/auth_provider.dart';

import '../../../../../core/error/failures.dart';
part 'signup_viewmodel.g.dart';

@riverpod
class SignupViewModel extends _$SignupViewModel {
  @override
  FutureOr<UserEntity?> build() {
    return null;
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    if (username.trim().isEmpty ||
        email.trim().isEmpty ||
        phoneNumber.trim().isEmpty ||
        password.isEmpty) {
      state = AsyncError(
        const AuthFailure('Please fill in all fields'),
        StackTrace.current,
      );
      return;
    }

    if (password.length < 6) {
      state = AsyncError(
        const AuthFailure('Password must be at least 6 characters'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    final useCase = ref.read(signUpUseCaseProvider);
    final result = await useCase(
      username: username.trim(),
      email: email.trim(),
      phoneNumber: phoneNumber.trim(),
      password: password,
    );

    state = result.when(
      success: (user) => AsyncData(user),
      failure: (failure) => AsyncError(failure, StackTrace.current),
    );
  }
}
