import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';

import '../../../../../core/constants/app_size.dart';
import '../../../../../core/router/route_paths.dart';
import '../../domain/entities/expense_entity.dart';
import '../../presentation/provider/expense_provider.dart';
import '../viewmodel/setup_expense_viewmodel.dart';

class SetupExpenseScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SetupExpenseScreen> createState() => _SetupExpenseScreenState();
}

class _SetupExpenseScreenState extends ConsumerState<SetupExpenseScreen> {
  final _busyProductIds = <String>{};

  Future<void> _onDelete(ExpenseEntity expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
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

    setState(() => _busyProductIds.add(expense.id));
    final result = await ref.read(deleteExpenseUsecaseProvider)(expense.id);
    if (!mounted) return;
    setState(() => _busyProductIds.remove(expense.id));

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
    final expensesAsync = ref.watch(setupExpenseViewModelProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(context.strings.otherExpense),
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
                  context.strings.expenseList,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: context.appColors.primary,
                  ),
                  onPressed: () => context.push(RoutePaths.newExpense),
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: expensesAsync.when(
                data: (expenses) {
                  if (expenses.isEmpty) {
                    return Center(child: Text(context.strings.emptyExpense));
                  }
                  return ListView.separated(
                    itemCount: expenses.length,
                    separatorBuilder: (_, __) => SizedBox(height: AppSizes.md),
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return _ExpenseCard(
                        expense: expense,
                        isBusy: _busyProductIds.contains(expense.id),
                        onDelete: () => _onDelete(expense),
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

class _ExpenseCard extends StatelessWidget {
  final ExpenseEntity expense;
  final bool isBusy;
  final VoidCallback onDelete;

  const _ExpenseCard({
    required this.expense,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  expense.name,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
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
        ],
      ),
    );
  }
}
