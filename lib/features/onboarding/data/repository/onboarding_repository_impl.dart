import 'package:zlux_pos/features/onboarding/domain/repository/onboarding_repository.dart';

import '../../../../core/local/app_local_storage.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final AppLocalStorage _localStorage;

  OnboardingRepositoryImpl(this._localStorage);

  static const String _key = 'has_completed_onboarding';

  @override
  Future<bool> hasCompletedOnboarding() {
    return _localStorage.getBool(_key);
  }

  @override
  Future<void> completeOnboarding() {
    return _localStorage.setBool(_key, true);
  }
}