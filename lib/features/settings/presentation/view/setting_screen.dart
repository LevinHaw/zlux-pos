import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zlux_pos/core/enum/app_language.dart';
import 'package:zlux_pos/core/enum/app_theme_mode.dart';
import 'package:zlux_pos/features/settings/presentation/viewmodel/setting_viewmodel.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_theme_mode.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final selected = await showDialog<AppLanguage>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(context.strings.lang),
        children: AppLanguage.values
            .map(
              (lang) => SimpleDialogOption(
                onPressed: () => Navigator.pop(dialogContext, lang),
                child: Text(context.strings.languageLabel(lang)),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null) {
      await ref.read(settingsViewModelProvider.notifier).setLanguage(selected);
    }
  }

  Future<void> _pickThemeMode(BuildContext context, WidgetRef ref) async {
    final selected = await showDialog<AppThemeMode>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(context.strings.theme),
        children: AppThemeMode.values
            .map(
              (mode) => SimpleDialogOption(
                onPressed: () => Navigator.pop(dialogContext, mode),
                child: Text(context.strings.themeModeLabel(mode)),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null) {
      await ref
          .read(settingsViewModelProvider.notifier)
          .setThemeMode(selected);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(settingsViewModelProvider);

    return MainScaffold(
      currentTab: MainTab.setting,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(context.strings.settings),
      ),
      body: asyncState.when(
        data: (state) => ListView(
          padding: EdgeInsets.all(AppSizes.lg),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: AppSizes.radiusLg,
                    backgroundColor: context.appColors.surface,
                    child: const Icon(Icons.person, size: 32),
                  ),
                  SizedBox(height: AppSizes.md),
                  Text(
                    state.merchantName ?? '—',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.lg),
            Container(
              padding: EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: context.appColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Column(
                children: [
                  Text(
                    context.strings.preferences,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: AppSizes.md),
                  _SettingsRow(
                    label: context.strings.email,
                    value: state.email ?? '—',
                  ),
                  const Divider(),
                  _SettingsRow(
                    label: context.strings.lang,
                    value: context.strings.languageLabel(state.language),
                    onTap: () => _pickLanguage(context, ref),
                  ),
                  const Divider(),
                  _SettingsRow(
                    label: context.strings.theme,
                    value: context.strings.themeModeLabel(state.themeMode),
                    onTap: () => _pickThemeMode(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _SettingsRow({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Row(
              children: [
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
                if (onTap != null) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 18),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
