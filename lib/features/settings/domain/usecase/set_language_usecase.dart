import 'package:zlux_pos/core/enum/app_language.dart';
import 'package:zlux_pos/features/settings/domain/repository/setting_repository.dart';

import '../entities/app_language.dart';

class SetLanguageUsecase {
  final SettingsRepository _repository;

  const SetLanguageUsecase(this._repository);

  Future<void> call(AppLanguage language) => _repository.setLanguage(language);
}
