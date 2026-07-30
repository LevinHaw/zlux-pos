import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zlux_pos/core/enum/app_theme_mode.dart';
import 'package:zlux_pos/core/localization/app_localizations.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/provider/app_preferences_provider.dart';
import 'package:zlux_pos/core/theme/app_theme.dart';

import 'core/router/app_router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final prefs = ref.watch(appPreferencesProvider);
    final localizations = AppLocalizations(prefs.language);

    return AppLocalizationsScope(
      language: prefs.language,
      child: MaterialApp.router(
        title: localizations.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: prefs.themeMode == AppThemeMode.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        routerConfig: router,
      ),
    );
  }
}
