import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/onboarding/presentation/provider/onboarding_provider.dart';


part 'onboarding_viewmodel.g.dart';


@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  int build() => 0; // current page index

  void setPage(int index) {
    state = index;
  }

  Future<void> complete() async {
    await ref.read(onboardingRepositoryProvider).completeOnboarding();
  }
}