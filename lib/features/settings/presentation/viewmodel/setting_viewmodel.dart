import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/enum/app_language.dart';
import 'package:zlux_pos/core/enum/app_theme_mode.dart';
import 'package:zlux_pos/core/provider/app_preferences_provider.dart';
import 'package:zlux_pos/features/setup/presentation/provider/setup_provider.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_theme_mode.dart';

part 'setting_viewmodel.g.dart';

class SettingsState {
  final String? email;
  final String? merchantName;
  final AppLanguage language;
  final AppThemeMode themeMode;

  const SettingsState({
    this.email,
    this.merchantName,
    this.language = AppLanguage.en,
    this.themeMode = AppThemeMode.dark,
  });

  SettingsState copyWith({
    String? email,
    String? merchantName,
    AppLanguage? language,
    AppThemeMode? themeMode,
  }) {
    return SettingsState(
      email: email ?? this.email,
      merchantName: merchantName ?? this.merchantName,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  Future<SettingsState> build() async {
    final prefs = ref.watch(appPreferencesProvider);

    final merchantUsecase = ref.watch(getMerchantUsecaseProvider);
    final merchantResult = await merchantUsecase();
    final merchantName = switch (merchantResult) {
      Success(:final data) => data?.name,
      ResultFailure() => null,
    };

    return SettingsState(
      email: FirebaseAuth.instance.currentUser?.email,
      merchantName: merchantName,
      language: prefs.language,
      themeMode: prefs.themeMode,
    );
  }

  Future<void> setLanguage(AppLanguage language) async {
    final current = state.valueOrNull ?? const SettingsState();
    await ref.read(appPreferencesProvider.notifier).setLanguage(language);
    state = AsyncData(current.copyWith(language: language));
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final current = state.valueOrNull ?? const SettingsState();
    await ref.read(appPreferencesProvider.notifier).setThemeMode(mode);
    state = AsyncData(current.copyWith(themeMode: mode));
  }
}
