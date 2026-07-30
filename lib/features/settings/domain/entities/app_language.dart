import 'package:zlux_pos/core/enum/app_language.dart';

extension AppLanguageX on AppLanguage {
  String get label {
    switch (this) {
      case AppLanguage.id:
        return 'Indonesia';
      case AppLanguage.en:
        return 'English';
    }
  }

  String get code {
    switch (this) {
      case AppLanguage.id:
        return 'id';
      case AppLanguage.en:
        return 'en';
    }
  }
}
