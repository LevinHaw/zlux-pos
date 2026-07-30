import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zlux_pos/core/enum/splash_destination.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../../core/constants/app_size.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate(SplashDestination destination) {
    if (_hasNavigated) return;
    _hasNavigated = true;

    switch (destination) {
      case SplashDestination.home:
        context.go('/home');
        break;
      case SplashDestination.login:
        context.go('/login');
        break;
      case SplashDestination.onboarding:
        context.go('/onboarding');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<SplashDestination>>(
      splashViewModelProvider,
      (previous, next) {
        next.whenData(_navigate);
      },
    );

    return Scaffold(
      backgroundColor: context.appColors.splashBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _LogoBadge(
              badgeColor: context.appColors.badgeDark,
              ringColor: context.appColors.accentOrange,
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({
    required this.badgeColor,
    required this.ringColor,
  });

  final Color badgeColor;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.splashBadgeSize,
      height: AppSizes.splashBadgeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: badgeColor,
        border: Border.all(color: ringColor, width: AppSizes.splashRingWidth),
        boxShadow: [
          BoxShadow(
            color: ringColor.withOpacity(0.35),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo_zlux.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const _FallbackLogo(),
        ),
      ),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ZLux',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          'POS',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}