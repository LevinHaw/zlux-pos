import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zlux_pos/features/home/domain/entities/dashboard_stats_entity.dart';
import 'package:zlux_pos/features/home/presentation/provider/home_provider.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../setup/domain/entities/merchant_entity.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantAsync = ref.watch(merchantProfileProvider);
    final statsAsync = ref.watch(homeDashboardStatsProvider);
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );

    return MainScaffold(
      currentTab: MainTab.home,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(context.strings.home),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSizes.lg),
        children: [
          _MerchantHeader(merchantAsync: merchantAsync),
          SizedBox(height: AppSizes.lg),
          Text(
            context.strings.bussinessData,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: AppSizes.md),
          statsAsync.when(
            data: (stats) => _StatsSection(stats: stats, currency: currency),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('$error'),
          ),
        ],
      ),
    );
  }
}

class _MerchantHeader extends StatelessWidget {
  final AsyncValue<MerchantEntity?> merchantAsync;

  const _MerchantHeader({required this.merchantAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.md),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.radiusMd / 1.5,
            backgroundColor: context.appColors.background,
            backgroundImage: merchantAsync.valueOrNull?.imageUrl != null
                ? NetworkImage(merchantAsync.valueOrNull!.imageUrl!)
                : null,
            child: merchantAsync.valueOrNull?.imageUrl == null
                ? const Icon(Icons.store)
                : null,
          ),
          SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchantAsync.valueOrNull?.name ?? '—',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  context.strings.brandMerchant,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final DashboardStatsEntity stats;
  final NumberFormat currency;

  const _StatsSection({required this.stats, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatCard(
          title: context.strings.totalTransactionToday,
          leftValue: '${stats.totalTransactions}',
          rightLabel: context.strings.amount,
          rightValue: currency.format(stats.totalAmount),
        ),
        SizedBox(height: AppSizes.md),
        _StatCard(
          title: context.strings.itemsPerOrder,
          leftValue: stats.averageItemsPerOrder.toStringAsFixed(1),
        ),
        SizedBox(height: AppSizes.md),
        _StatCard(
          title: context.strings.averageOrder,
          leftValue: currency.format(stats.averageOrderValue),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String leftValue;
  final String? rightLabel;
  final String? rightValue;

  const _StatCard({
    required this.title,
    required this.leftValue,
    this.rightLabel,
    this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.surface),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          SizedBox(height: AppSizes.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leftValue, style: Theme.of(context).textTheme.titleLarge),
              if (rightLabel != null && rightValue != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rightLabel!,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      rightValue!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
