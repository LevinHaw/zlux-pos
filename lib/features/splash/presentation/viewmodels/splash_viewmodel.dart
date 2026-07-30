import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/enum/splash_destination.dart';
import 'package:zlux_pos/features/expense_entry/presentation/provider/expense_entry_provider.dart';
import 'package:zlux_pos/features/income_entry/presentation/provider/income_entry_provider.dart';
import 'package:zlux_pos/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:zlux_pos/features/order/presentation/order_provider.dart';
import 'package:zlux_pos/features/setup/expense/presentation/provider/expense_provider.dart';
import 'package:zlux_pos/features/setup/income/presentation/provider/income_provider.dart';
import 'package:zlux_pos/features/setup/product/presentation/provider/product_provider.dart';

part 'splash_viewmodel.g.dart';


@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  Future<SplashDestination> build() async {
    final minDelay = Future.delayed(const Duration(seconds: 2));

    final destinationCheck = _resolveDestination();

    final results = await Future.wait([minDelay, destinationCheck]);
    final destination = results[1] as SplashDestination;

    return destination;
  }

  Future<SplashDestination> _resolveDestination() async {
    final onboardingRepository = ref.read(onboardingRepositoryProvider);
    final hasCompletedOnboarding =
        await onboardingRepository.hasCompletedOnboarding();

    if (!hasCompletedOnboarding) {
      return SplashDestination.onboarding;
    }

    return _checkAuthState();
  }

  Future<SplashDestination> _checkAuthState() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return SplashDestination.login;
    }
    try {
      await user.getIdToken(true);
      unawaited(_pullUserData());
      return SplashDestination.home;
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      return SplashDestination.login;
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