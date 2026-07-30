import 'package:zlux_pos/core/enum/app_language.dart';
import 'package:zlux_pos/features/settings/domain/repository/setting_repository.dart';

import '../entities/app_language.dart';

class GetLanguageUsecase {
  final SettingsRepository _repository;

  const GetLanguageUsecase(this._repository);

  Future<AppLanguage> call() => _repository.getLanguage();
}
