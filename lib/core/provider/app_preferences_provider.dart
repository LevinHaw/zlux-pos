import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zlux_pos/core/enum/app_language.dart';
import 'package:zlux_pos/core/enum/app_theme_mode.dart';
import 'package:zlux_pos/features/settings/presentation/provider/setting_provider.dart';

class AppPreferencesState {
  final AppLanguage language;
  final AppThemeMode themeMode;

  const AppPreferencesState({
    this.language = AppLanguage.en,
    this.themeMode = AppThemeMode.dark,
  });

  AppPreferencesState copyWith({
    AppLanguage? language,
    AppThemeMode? themeMode,
  }) {
    return AppPreferencesState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class AppPreferencesNotifier extends Notifier<AppPreferencesState> {
  @override
  AppPreferencesState build() {
   
    Future.microtask(_load);
    return const AppPreferencesState();
  }

  Future<void> _load() async {
    final language = await ref.read(getLanguageUsecaseProvider)();
    final themeMode = await ref.read(getThemeModeUsecaseProvider)();
    state = state.copyWith(language: language, themeMode: themeMode);
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    await ref.read(setLanguageUsecaseProvider)(language);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await ref.read(setThemeModeUsecaseProvider)(mode);
  }
}

final appPreferencesProvider =
    NotifierProvider<AppPreferencesNotifier, AppPreferencesState>(
      AppPreferencesNotifier.new,
    );
