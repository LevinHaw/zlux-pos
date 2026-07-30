import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zlux_pos/features/auth/domain/entities/user_entity.dart';
import 'package:zlux_pos/features/auth/presentation/provider/auth_provider.dart';
import 'package:zlux_pos/features/expense_entry/presentation/provider/expense_entry_provider.dart';
import 'package:zlux_pos/features/income_entry/presentation/provider/income_entry_provider.dart';
import 'package:zlux_pos/features/order/presentation/order_provider.dart';
import 'package:zlux_pos/features/setup/expense/presentation/provider/expense_provider.dart';
import 'package:zlux_pos/features/setup/income/presentation/provider/income_provider.dart';
import 'package:zlux_pos/features/setup/product/presentation/provider/product_provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/router/route_paths.dart';

part 'login_viewmodel.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  FutureOr<UserEntity?> build() {
    return null;
  }

  Future<void> signIn({required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      state = AsyncError(
        const AuthFailure('Please fill in both fields'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    final useCase = ref.read(signInUseCaseProvider);
    final result = await useCase(email: email.trim(), password: password);

    state = result.when(
      success: (user) => AsyncData(user),
      failure: (failure) => AsyncError(failure, StackTrace.current),
    );

    if (result.isSuccess) {
      unawaited(_pullUserData());
    }
  }

  Future<void> _pullUserData() async {
    await Future.wait([
      ref.read(pullProductsUsecaseProvider)(),
      ref.read(pullCategoriesUsecaseProvider)(),
      ref.read(pullOrdersUsecaseProvider)(),
      ref.read(pullExpenseUsecaseProvider)(),
      ref.read(pullIncomeUsecaseProvider)(),
      ref.read(pullExpenseEntriesUsecaseProvider)(),
      ref.read(pullIncomeEntriesUsecaseProvider)(),
    ]);
  }
}