import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors_ext.dart';
import '../constants/app_size.dart';
import '../router/route_paths.dart';
import '../localization/app_localizations_scope.dart';

enum MainTab { home, history, setup, setting }

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.currentTab,
    required this.body,
    this.backgroundColor,
    this.appBar,
  });

  final MainTab currentTab;
  final Widget body;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;

  void _onFabTap(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheetContext.strings.chooseAction,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
                SizedBox(height: AppSizes.md),
                _FabOption(
                  icon: Icons.point_of_sale_rounded,
                  color: sheetContext.appColors.accentOrange,
                  title: sheetContext.strings.newTransaction,
                  subtitle: sheetContext.strings.newTransactionSubtitle,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    sheetContext.push(RoutePaths.transaction);
                  },
                ),
                SizedBox(height: AppSizes.sm),
                _FabOption(
                  icon: Icons.arrow_downward_rounded,
                  color: sheetContext.appColors.success,
                  title: sheetContext.strings.incomeEntry,
                  subtitle: sheetContext.strings.incomeEntrySubtitle,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    sheetContext.push(RoutePaths.newIncomeEntry);
                  },
                ),
                SizedBox(height: AppSizes.sm),
                _FabOption(
                  icon: Icons.arrow_upward_rounded,
                  color: sheetContext.appColors.error,
                  title: sheetContext.strings.expenseEntry,
                  subtitle: sheetContext.strings.expenseEntrySubtitle,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    sheetContext.push(RoutePaths.newExpenseEntry);
                  },
                ),
                SizedBox(height: AppSizes.sm),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTap(BuildContext context, MainTab tab) {
    if (tab == currentTab) return;
    switch (tab) {
      case MainTab.home:
        context.go(RoutePaths.home);
        break;
      case MainTab.history:
        context.go(RoutePaths.history);
        break;
      case MainTab.setup:
        context.go(RoutePaths.setup);
        break;
      case MainTab.setting:
        context.go(RoutePaths.setting);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? context.appColors.background,
      appBar: appBar,
      body: body,
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.appColors.accentOrange,
        foregroundColor: Colors.white,
        onPressed: () => _onFabTap(context),
        child: const Icon(Icons.add, size: AppSizes.iconLg),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: context.appColors.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: AppSizes.md,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: context.strings.home,
                selected: currentTab == MainTab.home,
                onTap: () => _onTap(context, MainTab.home),
              ),
              _NavItem(
                icon: Icons.receipt_long_rounded,
                label: context.strings.history,
                selected: currentTab == MainTab.history,
                onTap: () => _onTap(context, MainTab.history),
              ),
              const SizedBox(width: AppSizes.xxl),
              _NavItem(
                icon: Icons.build_rounded,
                label: context.strings.setup,
                selected: currentTab == MainTab.setup,
                onTap: () => _onTap(context, MainTab.setup),
              ),
              _NavItem(
                icon: Icons.menu_rounded,
                label: context.strings.settings,
                selected: currentTab == MainTab.setting,
                onTap: () => _onTap(context, MainTab.setting),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FabOption extends StatelessWidget {
  const _FabOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected
            ? context.appColors.accentOrange
            : context.appColors.badgeDark.withOpacity(0.5);

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSizes.iconMd),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: AppSizes.fontXs,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
