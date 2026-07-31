import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zlux_pos/features/home/domain/entities/dashboard_stats_entity.dart';
import 'package:zlux_pos/features/home/presentation/provider/home_provider.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../setup/domain/entities/merchant_entity.dart';
import '../../domain/entities/daily_report_entity.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (result != null) {
      setState(() => _selectedDate = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final merchantAsync = ref.watch(merchantProfileProvider);
    final statsAsync = ref.watch(homeDashboardStatsProvider);
    final reportAsync = ref.watch(dailyReportProvider(_selectedDate));
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
        padding: EdgeInsets.only(top: AppSizes.lg, left: AppSizes.lg, right: AppSizes.lg, bottom: AppSizes.xxl),
        children: [
          _MerchantHeader(merchantAsync: merchantAsync),
          SizedBox(height: AppSizes.lg),
          _DailyReportHeader(
            date: _selectedDate,
            onPickDate: _pickDate,
          ),
          SizedBox(height: AppSizes.md),
          reportAsync.when(
            data: (report) =>
                _DailyReportSection(report: report, currency: currency),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('$error'),
          ),
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
          SizedBox(height: AppSizes.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.push(RoutePaths.report),
              icon: const Icon(Icons.assessment_outlined),
              label: Text(context.strings.reportMenu),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyReportHeader extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPickDate;

  const _DailyReportHeader({required this.date, required this.onPickDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.strings.dailyReport,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        TextButton.icon(
          onPressed: onPickDate,
          icon: const Icon(Icons.calendar_today, size: AppSizes.iconSm),
          label: Text(DateFormat('d MMMM yyyy').format(date)),
        ),
      ],
    );
  }
}

class _DailyReportSection extends StatelessWidget {
  final DailyReportEntity report;
  final NumberFormat currency;

  const _DailyReportSection({required this.report, required this.currency});

  @override
  Widget build(BuildContext context) {
    final isProfit = report.profit >= 0;

    return Column(
      children: [
        _ReportCard(
          title: context.strings.reportTransactionIncome,
          leftValue: '${report.totalTransactions}',
          rightLabel: context.strings.amount,
          rightValue: currency.format(report.transactionIncome),
        ),
        SizedBox(height: AppSizes.md),
        _ReportCard(
          title: context.strings.reportIncomeEntry,
          leftValue: currency.format(report.incomeEntryAmount),
        ),
        SizedBox(height: AppSizes.md),
        _ReportCard(
          title: context.strings.reportTotalIncome,
          leftValue: currency.format(report.totalIncome),
          valueColor: context.appColors.success,
        ),
        SizedBox(height: AppSizes.md),
        _ReportCard(
          title: context.strings.reportTotalExpense,
          leftValue: currency.format(report.totalExpense),
          valueColor: context.appColors.error,
        ),
        SizedBox(height: AppSizes.md),
        _ReportCard(
          title: context.strings.reportProfit,
          leftValue: currency.format(report.profit),
          valueColor: isProfit
              ? context.appColors.success
              : context.appColors.error,
          highlighted: true,
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String leftValue;
  final String? rightLabel;
  final String? rightValue;
  final Color? valueColor;
  final bool highlighted;

  const _ReportCard({
    required this.title,
    required this.leftValue,
    this.rightLabel,
    this.rightValue,
    this.valueColor,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: highlighted ? context.appColors.surface : null,
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
              Text(
                leftValue,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: valueColor,
                    ),
              ),
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

