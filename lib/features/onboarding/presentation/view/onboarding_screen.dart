import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zlux_pos/features/onboarding/domain/entities/onboarding_page_entitiy.dart';
import 'package:zlux_pos/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:zlux_pos/features/onboarding/presentation/viewmodel/onboarding_viewmodel.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/router/route_paths.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingViewModelProvider.notifier).complete();
    if (mounted) context.go(RoutePaths.login);
  }

  void _next(int lastIndex) {
    final current = ref.read(onboardingViewModelProvider);
    if (current == lastIndex) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(onboardingPagesProvider);
    final currentIndex = ref.watch(onboardingViewModelProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      ref
                          .read(onboardingViewModelProvider.notifier)
                          .setPage(index);
                    },
                    itemBuilder: (context, index) {
                      return _OnboardingSlide(
                        page: pages[index],
                        isLastPage: index == pages.length - 1,
                        onSkip: _finish,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                  child: _PageIndicator(
                    count: pages.length,
                    currentIndex: currentIndex,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg,
                  ).copyWith(bottom: AppSizes.lg),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _next(pages.length - 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColors.accentOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusFull,
                          ),
                        ),
                      ),
                      child: Text(
                        currentIndex == pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.page,
    required this.isLastPage,
    required this.onSkip,
  });

  final OnboardingPageEntity page;
  final bool isLastPage;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.appColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isLastPage ? null : onSkip,
                  child: Text(
                    isLastPage ? '' : 'Skip',
                    style: TextStyle(color: context.appColors.textSecondary),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Image.asset(page.image, fit: BoxFit.fill),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Column(
            children: [
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppSizes.fontXxl,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                page.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.appColors.authTextMuted,
                  fontSize: AppSizes.fontSm,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  IconData _iconFor(String label) {
    switch (label) {
      case 'OnBoarding':
        return Icons.storefront_rounded;
      case 'OnBoarding2':
        return Icons.bar_chart_rounded;
      case 'OnBoarding3':
        return Icons.receipt_long_rounded;
      default:
        return Icons.storefront_rounded;
    }
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.currentIndex});
  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? context.appColors.accentOrange : context.appColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
        );
      }),
    );
  }
}
