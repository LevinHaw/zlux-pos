import 'package:zlux_pos/core/enum/app_theme_mode.dart';
import 'package:zlux_pos/features/settings/domain/repository/setting_repository.dart';

import '../entities/app_theme_mode.dart';

class SetThemeModeUsecase {
  final SettingsRepository _repository;

  const SetThemeModeUsecase(this._repository);

  Future<void> call(AppThemeMode mode) => _repository.setThemeMode(mode);
}
