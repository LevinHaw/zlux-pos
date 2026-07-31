import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zlux_pos/features/home/presentation/provider/home_provider.dart';
import 'package:zlux_pos/features/report/domain/entities/daily_report_detail_entity.dart';
import 'package:zlux_pos/features/report/presentation/provider/report_provider.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';

class ReportDetailScreen extends ConsumerStatefulWidget {
  final DateTime date;

  const ReportDetailScreen({super.key, required this.date});

  @override
  ConsumerState<ReportDetailScreen> createState() =>
      _ReportDetailScreenState();
}

class _ReportDetailScreenState extends ConsumerState<ReportDetailScreen> {
  bool _isExporting = false;

  Future<void> _exportPdf(DailyReportDetailEntity report) async {
    setState(() => _isExporting = true);
    try {
      final merchant = await ref.read(merchantProfileProvider.future);
      final service = ref.read(dailyReportPdfServiceProvider);
      await service.exportAndShare(
        report: report,
        merchantName: merchant?.name,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(dailyReportDetailProvider(widget.date));
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(DateFormat('d MMMM yyyy').format(widget.date)),
        actions: [
          reportAsync.maybeWhen(
            data: (report) => IconButton(
              icon: _isExporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf_outlined),
              onPressed: _isExporting ? null : () => _exportPdf(report),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: reportAsync.when(
        data: (report) => _ReportDetailBody(report: report, currency: currency),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
      ),
    );
  }
}

class _ReportDetailBody extends StatelessWidget {
  final DailyReportDetailEntity report;
  final NumberFormat currency;

  const _ReportDetailBody({required this.report, required this.currency});

  @override
  Widget build(BuildContext context) {
    final isProfit = report.profit >= 0;

    return ListView(
      padding: EdgeInsets.all(AppSizes.lg),
      children: [
        _SectionTitle(context.strings.reportProductDetail),
        SizedBox(height: AppSizes.sm),
        if (report.productSummaries.isEmpty)
          _EmptyHint(context.strings.noOrdersThisDay)
        else
          _ProductTable(report: report, currency: currency),
        SizedBox(height: AppSizes.sm),
        _KeyValueRow(
          label: context.strings.totalTransactionToday,
          value: '${report.totalTransactions}',
        ),
        _KeyValueRow(
          label: context.strings.reportTransactionIncome,
          value: currency.format(report.transactionIncome),
        ),
        SizedBox(height: AppSizes.lg),

        _SectionTitle(context.strings.reportPaymentMethod),
        SizedBox(height: AppSizes.sm),
        _KeyValueRow(
          label: context.strings.reportCash,
          value: currency.format(report.cashTotal),
        ),
        _KeyValueRow(
          label: context.strings.reportTransfer,
          value: currency.format(report.transferTotal),
        ),
        SizedBox(height: AppSizes.lg),

        _SectionTitle(context.strings.incomeEntry),
        SizedBox(height: AppSizes.sm),
        if (report.incomeEntries.isEmpty)
          _EmptyHint(context.strings.noOrdersThisDay)
        else
          for (final entry in report.incomeEntries)
            _EntryRow(
              label: entry.incomeName,
              value: currency.format(entry.amount),
              note: entry.note,
            ),
        SizedBox(height: AppSizes.lg),

        _SectionTitle(context.strings.expenseEntry),
        SizedBox(height: AppSizes.sm),
        if (report.expenseEntries.isEmpty)
          _EmptyHint(context.strings.noOrdersThisDay)
        else
          for (final entry in report.expenseEntries)
            _EntryRow(
              label: entry.expenseName,
              value: currency.format(entry.amount),
              note: entry.note,
            ),
        SizedBox(height: AppSizes.lg),

        const Divider(),
        SizedBox(height: AppSizes.sm),
        _KeyValueRow(
          label: context.strings.reportTotalIncome,
          value: currency.format(report.totalIncome),
          bold: true,
          valueColor: context.appColors.success,
        ),
        _KeyValueRow(
          label: context.strings.reportTotalExpense,
          value: currency.format(report.totalExpense),
          bold: true,
          valueColor: context.appColors.error,
        ),
        _KeyValueRow(
          label: context.strings.reportProfit,
          value: currency.format(report.profit),
          bold: true,
          valueColor:
              isProfit ? context.appColors.success : context.appColors.error,
        ),
        SizedBox(height: AppSizes.lg),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _KeyValueRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: valueColor)
        : Theme.of(context).textTheme.bodyMedium?.copyWith(color: valueColor);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: bold ? style : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  final String label;
  final String value;
  final String note;

  const _EntryRow({
    required this.label,
    required this.value,
    this.note = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          if (note.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: AppSizes.xs / 2),
              child: Text(
                note,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductTable extends StatelessWidget {
  final DailyReportDetailEntity report;
  final NumberFormat currency;

  const _ProductTable({required this.report, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2),
      },
      border: TableBorder.symmetric(
        inside: BorderSide(color: context.appColors.surface),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: context.appColors.surface),
          children: [
            _headerCell(context, context.strings.product),
            _headerCell(context, context.strings.quantity, alignRight: true),
            _headerCell(context, context.strings.amount, alignRight: true),
          ],
        ),
        for (final product in report.productSummaries)
          TableRow(
            children: [
              _cell(context, product.productName),
              _cell(context, '${product.quantity}', alignRight: true),
              _cell(context, currency.format(product.amount), alignRight: true),
            ],
          ),
      ],
    );
  }

  Widget _headerCell(BuildContext context, String text, {bool alignRight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _cell(BuildContext context, String text, {bool alignRight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
