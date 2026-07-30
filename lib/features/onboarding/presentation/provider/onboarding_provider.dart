import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/localization/app_localizations.dart';
import 'package:zlux_pos/core/provider/app_preferences_provider.dart';
import 'package:zlux_pos/features/onboarding/data/repository/onboarding_repository_impl.dart';
import 'package:zlux_pos/features/onboarding/domain/entities/onboarding_page_entitiy.dart';
import 'package:zlux_pos/features/onboarding/domain/repository/onboarding_repository.dart';

import '../../../../core/local/app_local_storage.dart';

part 'onboarding_provider.g.dart';

@riverpod
AppLocalStorage appLocalStorage(Ref ref) {
  return AppLocalStorage();
}

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepositoryImpl(ref.watch(appLocalStorageProvider));
}

@riverpod
List<OnboardingPageEntity> onboardingPages(Ref ref) {
  final language = ref.watch(appPreferencesProvider).language;
  final strings = AppLocalizations(language);

  return [
    OnboardingPageEntity(
      label: 'OnBoarding',
      title: strings.onboard,
      image: 'assets/images/onboard1.png',
      description: strings.subOnboard,
    ),
    OnboardingPageEntity(
      label: 'OnBoarding2',
      title: strings.onboard2,
      image: 'assets/images/onboard2.png',
      description: strings.subOnboard2,
    ),
    OnboardingPageEntity(
      label: 'OnBoarding3',
      title: strings.onboard3,
      image: 'assets/images/onboard3.png',
      description: strings.subOnboard3,
    ),
  ];
}
