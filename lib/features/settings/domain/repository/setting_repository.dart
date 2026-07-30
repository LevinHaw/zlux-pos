import 'package:zlux_pos/core/enum/app_language.dart';
import 'package:zlux_pos/core/enum/app_theme_mode.dart';

import '../entities/app_language.dart';
import '../entities/app_theme_mode.dart';

abstract class SettingsRepository {
  Future<AppLanguage> getLanguage();
  Future<void> setLanguage(AppLanguage language);

  Future<AppThemeMode> getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);
}
