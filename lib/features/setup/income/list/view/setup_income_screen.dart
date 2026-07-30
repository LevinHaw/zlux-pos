import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zlux_pos/core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/router/route_paths.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';
import 'package:zlux_pos/features/setup/income/list/viewmodel/setup_income_viewmodel.dart';
import 'package:zlux_pos/features/setup/income/presentation/provider/income_provider.dart';

class SetupIncomeScreen extends ConsumerStatefulWidget {
  const SetupIncomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SetupIncomeScreenState();
  }
}

class _SetupIncomeScreenState extends ConsumerState<SetupIncomeScreen> {
  final _busyProductIds = <String>{};

  Future<void> _onDelete(IncomeEntity income) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(dialogContext.strings.deleteIncome),
            content: Text(dialogContext.strings.deleteIncomeMessage),
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

    setState(() => _busyProductIds.add(income.id));
    final result = await ref.read(deleteIncomeUsecaseProvider)(income.id);
    if (!mounted) return;
    setState(() => _busyProductIds.remove(income.id));

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
    final incomesAsync = ref.watch(setupIncomeViewModelProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(context.strings.otherIncome),
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
                  context.strings.incomeList,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: context.appColors.primary,
                  ),
                  onPressed: () => context.push(RoutePaths.newIncome),
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: incomesAsync.when(
                data: (incomes) {
                  if (incomes.isEmpty) {
                    return Center(child: Text(context.strings.emptyIncome));
                  }
                  return ListView.separated(
                    itemCount: incomes.length,
                    separatorBuilder: (_, __) => SizedBox(height: AppSizes.md),
                    itemBuilder: (context, index) {
                      final income = incomes[index];
                      return _IncomeCard(
                        income: income,
                        isBusy: _busyProductIds.contains(income.id),
                        onDelete: () => _onDelete(income),
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

class _IncomeCard extends StatelessWidget {
  final IncomeEntity income;
  final bool isBusy;
  final VoidCallback onDelete;

  const _IncomeCard({
    required this.income,
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
                  income.name,
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
