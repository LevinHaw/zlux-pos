import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zlux_pos/features/order/presentation/order_provider.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../../core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import '../../../../../core/router/route_paths.dart';
import '../../../../../core/widgets/main_scaffold.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  Future<void> _pickMonth() async {
    int tempYear = _year;
    int tempMonth = _month;

    final result = await showDialog<(int, int)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(context.strings.select),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setDialogState(() {
                  if (tempMonth == 1) {
                    tempMonth = 12;
                    tempYear--;
                  } else {
                    tempMonth--;
                  }
                }),
              ),
              SizedBox(
                width: 140,
                child: Text(
                  DateFormat('MMMM yyyy').format(DateTime(tempYear, tempMonth)),
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setDialogState(() {
                  if (tempMonth == 12) {
                    tempMonth = 1;
                    tempYear++;
                  } else {
                    tempMonth++;
                  }
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, (tempYear, tempMonth)),
              child: Text(context.strings.select),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _year = result.$1;
        _month = result.$2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final datesAsync = ref.watch(
      historyDatesProvider(year: _year, month: _month),
    );

    return MainScaffold(
      currentTab: MainTab.history,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(context.strings.history),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.strings.month,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: _pickMonth,
                  child: Text(DateFormat('MMMM').format(DateTime(_year, _month))),
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: datesAsync.when(
                data: (dates) {
                  if (dates.isEmpty) {
                    return Center(
                      child: Text(context.strings.noOrdersThisDay),
                    );
                  }
                  return ListView.separated(
                    itemCount: dates.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSizes.md),
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      return _DateButton(
                        date: date,
                        onTap: () => context.push(
                          '${RoutePaths.historyOrder}/'
                          '${DateFormat('yyyy-MM-dd').format(date)}',
                        ),
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('$error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const _DateButton({required this.date, required this.onTap});

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
          child: Text(DateFormat('d MMMM yyyy').format(date)),
        ),
      ),
    );
  }
}
