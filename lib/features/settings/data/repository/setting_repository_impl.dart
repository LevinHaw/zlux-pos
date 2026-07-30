import 'package:zlux_pos/core/enum/app_language.dart';
import 'package:zlux_pos/core/enum/app_theme_mode.dart';
import 'package:zlux_pos/features/settings/data/datasource/setting_local_datasource.dart';
import 'package:zlux_pos/features/settings/domain/repository/setting_repository.dart';

import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_theme_mode.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _local;

  const SettingsRepositoryImpl(this._local);

  @override
  Future<AppLanguage> getLanguage() async {
    final code = await _local.getLanguage();
    return code == 'id' ? AppLanguage.id : AppLanguage.en;
  }

  @override
  Future<void> setLanguage(AppLanguage language) {
    return _local.setLanguage(language.code);
  }

  @override
  Future<AppThemeMode> getThemeMode() async {
    final mode = await _local.getThemeMode();
    return mode == 'light' ? AppThemeMode.light : AppThemeMode.dark;
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) {
    return _local.setThemeMode(mode.name);
  }
}
