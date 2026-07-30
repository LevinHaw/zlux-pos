import 'package:flutter/material.dart';

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  final Color splashBackground;
  final Color badgeDark;
  final Color accentOrange;
  final Color primary;
  final Color background;
  final Color surface;
  final Color error;
  final Color success;
  final Color warning;
  final Color textPrimary;
  final Color textSecondary;
  final Color textOnDark;
  final Color authInputFill;
  final Color authTextMuted;

  const AppColorsExt({
    required this.splashBackground,
    required this.badgeDark,
    required this.accentOrange,
    required this.primary,
    required this.background,
    required this.surface,
    required this.error,
    required this.success,
    required this.warning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textOnDark,
    required this.authInputFill,
    required this.authTextMuted,
  });

  static const dark = AppColorsExt(
    splashBackground: Color(0xFFE8FB8C),
    badgeDark: Color(0xFF1A1E21),
    accentOrange: Color(0xFFFF8F00),
    primary: Color(0xFFBBDF4B),
    background: Color(0xFF283335),
    surface: Color(0xFF414E53),
    error: Color(0xFFE53935),
    success: Color(0xFF43A047),
    warning: Color(0xFFFFB300),
    textPrimary: Colors.white,
    textSecondary: Colors.grey,
    textOnDark: Colors.white,
    authInputFill: Color(0xFF3A4444),
    authTextMuted: Color(0xFF9AA5A5),
  );

  static const light = AppColorsExt(
    splashBackground: Color(0xFFE8FB8C),
    badgeDark: Color(0xFF1A1E21),
    accentOrange: Color(0xFFFF8F00),
    primary: Color(0xFF6B9B1E),
    background: Color(0xFFF7F8F5),
    surface: Color(0xFFDCCFC0),
    error: Color(0xFFD32F2F),
    success: Color(0xFF388E3C),
    warning: Color(0xFFF9A825),
    textPrimary: Color(0xFF1A1E21),
    textSecondary: Color(0xFF5C6B6B),
    textOnDark: Colors.white,
    authInputFill: Color(0xFFEFF2EF),
    authTextMuted: Color(0xFF7A8787),
  );

  @override
  AppColorsExt copyWith({
    Color? splashBackground,
    Color? badgeDark,
    Color? accentOrange,
    Color? primary,
    Color? background,
    Color? surface,
    Color? error,
    Color? success,
    Color? warning,
    Color? textPrimary,
    Color? textSecondary,
    Color? textOnDark,
    Color? authInputFill,
    Color? authTextMuted,
  }) {
    return AppColorsExt(
      splashBackground: splashBackground ?? this.splashBackground,
      badgeDark: badgeDark ?? this.badgeDark,
      accentOrange: accentOrange ?? this.accentOrange,
      primary: primary ?? this.primary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textOnDark: textOnDark ?? this.textOnDark,
      authInputFill: authInputFill ?? this.authInputFill,
      authTextMuted: authTextMuted ?? this.authTextMuted,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      splashBackground:
          Color.lerp(splashBackground, other.splashBackground, t)!,
      badgeDark: Color.lerp(badgeDark, other.badgeDark, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textOnDark: Color.lerp(textOnDark, other.textOnDark, t)!,
      authInputFill: Color.lerp(authInputFill, other.authInputFill, t)!,
      authTextMuted: Color.lerp(authTextMuted, other.authTextMuted, t)!,
    );
  }
}

/// Convenience accessor: `context.appColors.background` instead of
/// `Theme.of(context).extension<AppColorsExt>()!.background`.
extension AppColorsExtX on BuildContext {
  AppColorsExt get appColors => Theme.of(this).extension<AppColorsExt>()!;
}
