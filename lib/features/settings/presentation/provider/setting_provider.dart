import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/settings/data/datasource/setting_local_datasource.dart';
import 'package:zlux_pos/features/settings/data/repository/setting_repository_impl.dart';
import 'package:zlux_pos/features/settings/domain/repository/setting_repository.dart';
import 'package:zlux_pos/features/settings/domain/usecase/get_language_usecase.dart';
import 'package:zlux_pos/features/settings/domain/usecase/get_theme_mode_usecase.dart';
import 'package:zlux_pos/features/settings/domain/usecase/set_language_usecase.dart';
import 'package:zlux_pos/features/settings/domain/usecase/set_theme_mode_usecase.dart';


part 'setting_provider.g.dart';

@riverpod
SettingsLocalDataSource settingsLocalDataSource(
  SettingsLocalDataSourceRef ref,
) {
  return SettingsLocalDataSource();
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepositoryImpl(ref.watch(settingsLocalDataSourceProvider));
}

@riverpod
GetLanguageUsecase getLanguageUsecase(GetLanguageUsecaseRef ref) {
  return GetLanguageUsecase(ref.watch(settingsRepositoryProvider));
}

@riverpod
SetLanguageUsecase setLanguageUsecase(SetLanguageUsecaseRef ref) {
  return SetLanguageUsecase(ref.watch(settingsRepositoryProvider));
}

@riverpod
GetThemeModeUsecase getThemeModeUsecase(GetThemeModeUsecaseRef ref) {
  return GetThemeModeUsecase(ref.watch(settingsRepositoryProvider));
}

@riverpod
SetThemeModeUsecase setThemeModeUsecase(SetThemeModeUsecaseRef ref) {
  return SetThemeModeUsecase(ref.watch(settingsRepositoryProvider));
}
