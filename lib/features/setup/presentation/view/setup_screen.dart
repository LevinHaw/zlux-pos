import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/main_scaffold.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentTab: MainTab.setup,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(context.strings.setup),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
        child: Column(
          children: [
            SizedBox(height: AppSizes.md),
            _SetupMenuButton(
              label: context.strings.setupMerchant,
              onTap: () => context.push(RoutePaths.setupMerchant),
            ),
            SizedBox(height: AppSizes.md),
            _SetupMenuButton(
              label: context.strings.setupProduct,
              onTap: () => context.push(RoutePaths.setupProduct),
            ),
            SizedBox(height: AppSizes.md),
            _SetupMenuButton(
              label: context.strings.setupDataIncome,
              onTap: () => context.push(RoutePaths.setupIncome),
            ),
            SizedBox(height: AppSizes.md),
            _SetupMenuButton(
              label: context.strings.setupDataExpense,
              onTap: () => context.push(RoutePaths.setupExpense),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetupMenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SetupMenuButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.primary,
      borderRadius: BorderRadius.circular(AppSizes.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.md),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
