import 'package:zlux_pos/core/enum/app_theme_mode.dart';
import 'package:zlux_pos/features/settings/domain/repository/setting_repository.dart';

import '../entities/app_theme_mode.dart';

class GetThemeModeUsecase {
  final SettingsRepository _repository;

  const GetThemeModeUsecase(this._repository);

  Future<AppThemeMode> call() => _repository.getThemeMode();
}
