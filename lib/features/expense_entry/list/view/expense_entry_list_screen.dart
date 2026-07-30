import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zlux_pos/core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/router/route_paths.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import 'package:zlux_pos/features/expense_entry/domain/entities/expense_entry_entity.dart';
import 'package:zlux_pos/features/expense_entry/list/viewmodel/expense_entry_list_viewmodel.dart';
import 'package:zlux_pos/features/expense_entry/presentation/provider/expense_entry_provider.dart';

class ExpenseEntryListScreen extends ConsumerStatefulWidget {
  const ExpenseEntryListScreen({super.key});

  @override
  ConsumerState<ExpenseEntryListScreen> createState() =>
      _ExpenseEntryListScreenState();
}

class _ExpenseEntryListScreenState
    extends ConsumerState<ExpenseEntryListScreen> {
  final _busyIds = <String>{};

  Future<void> _onDelete(ExpenseEntryEntity entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.strings.deleteExpense),
        content: Text(dialogContext.strings.deleteExpenseMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(dialogContext.strings.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _busyIds.add(entry.id));
    final result = await ref.read(deleteExpenseEntryUsecaseProvider)(entry.id);
    if (!mounted) return;
    setState(() => _busyIds.remove(entry.id));

    result.when(
      success: (_) {},
      failure: (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(expenseEntryListViewModelProvider);
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(context.strings.expenseEntries),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.appColors.accentOrange,
        foregroundColor: Colors.white,
        onPressed: () => context.push(RoutePaths.newExpenseEntry),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.md),
            Text(
              context.strings.expenseEntryList,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: entriesAsync.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return Center(
                      child: Text(context.strings.emptyExpenseEntry),
                    );
                  }
                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSizes.md),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _EntryCard(
                        title: entry.expenseName,
                        note: entry.note,
                        date: dateFormat.format(entry.date),
                        amountText: currency.format(entry.amount),
                        amountColor: context.appColors.success,
                        isBusy: _busyIds.contains(entry.id),
                        onDelete: () => _onDelete(entry),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('$error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final String title;
  final String note;
  final String date;
  final String amountText;
  final Color amountColor;
  final bool isBusy;
  final VoidCallback onDelete;

  const _EntryCard({
    required this.title,
    required this.note,
    required this.date,
    required this.amountText,
    required this.amountColor,
    required this.isBusy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.xs),
                Text(
                  note.isEmpty ? date : '$date • $note',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSizes.sm),
          Text(
            amountText,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: amountColor),
          ),
          if (isBusy)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
