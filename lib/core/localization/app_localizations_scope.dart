import 'package:flutter/widgets.dart';
import 'package:zlux_pos/core/enum/app_language.dart';

import 'app_localizations.dart';

class AppLocalizationsScope extends InheritedWidget {
  final AppLanguage language;

  const AppLocalizationsScope({
    super.key,
    required this.language,
    required super.child,
  });

  static AppLocalizations of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppLocalizationsScope>();
    return AppLocalizations(scope?.language ?? AppLanguage.en);
  }

  @override
  bool updateShouldNotify(AppLocalizationsScope oldWidget) =>
      oldWidget.language != language;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get strings => AppLocalizationsScope.of(this);
}
