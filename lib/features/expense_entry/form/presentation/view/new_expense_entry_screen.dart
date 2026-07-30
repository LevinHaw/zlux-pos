import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zlux_pos/core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import 'package:zlux_pos/features/expense_entry/form/presentation/viewmodel/new_expense_entry_viewmodel.dart';
import 'package:zlux_pos/features/setup/expense/domain/entities/expense_entity.dart';
import 'package:zlux_pos/features/setup/expense/presentation/provider/expense_provider.dart';

import '../../../../../core/utils/currency_input_formatter.dart';

class NewExpenseEntryScreen extends ConsumerStatefulWidget {
  final String? entryId;
  const NewExpenseEntryScreen({super.key, this.entryId});

  @override
  ConsumerState<NewExpenseEntryScreen> createState() =>
      _NewExpenseEntryScreenState();
}

class _NewExpenseEntryScreenState extends ConsumerState<NewExpenseEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedExpenseId;
  DateTime _selectedDate = DateTime.now();
  bool _prefilled = false;
  List<ExpenseEntity> _latestOptions = const [];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _prefillIfNeeded(NewExpenseEntryState state, List<ExpenseEntity> options) {
    if (_prefilled || state.initial == null) return;
    final initial = state.initial!;
    _amountController.text = CurrencyInputFormatter.formatValue(
      initial.amount,
    );
    _noteController.text = initial.note;
    _selectedDate = initial.date;
    _selectedExpenseId = initial.expenseId;
    _prefilled = true;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final selected = _latestOptions
        .where((o) => o.id == _selectedExpenseId)
        .toList();
    if (selected.isEmpty) return;
    final selectedExpense = selected.first;

    final amount = CurrencyInputFormatter.parse(_amountController.text);

    await ref
        .read(newExpenseEntryViewModelProvider(widget.entryId).notifier)
        .save(
          expenseId: selectedExpense.id,
          expenseName: selectedExpense.name,
          amount: amount,
          note: _noteController.text,
          date: _selectedDate,
        );

    if (!mounted) return;
    final state =
        ref.read(newExpenseEntryViewModelProvider(widget.entryId)).valueOrNull;

    if (state?.isSaved == true) {
      Navigator.of(context).pop();
    } else if (state?.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state!.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState =
        ref.watch(newExpenseEntryViewModelProvider(widget.entryId));
    final expenseOptionsAsync = ref.watch(watchExpenseUsecaseProvider).call();

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(context.strings.expenseEntry),
      ),
      body: SafeArea(
        child: asyncState.when(
          data: (state) {
            return StreamBuilder<List<ExpenseEntity>>(
              stream: expenseOptionsAsync,
              builder: (context, snapshot) {
                final options = snapshot.data ?? const <ExpenseEntity>[];
                _latestOptions = options;
                _prefillIfNeeded(state, options);
                final selectedExists =
                    options.any((o) => o.id == _selectedExpenseId);

                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    children: [
                      SizedBox(height: AppSizes.lg),
                      Text(
                        context.strings.expenseCategory,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(height: AppSizes.md),
                      options.isEmpty
                          ? Text(
                              context.strings.emptyExpense,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : DropdownButtonFormField<String>(
                              value: selectedExists ? _selectedExpenseId : null,
                              items: options
                                  .map(
                                    (expense) => DropdownMenuItem(
                                      value: expense.id,
                                      child: Text(expense.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedExpenseId = value),
                              validator: (value) =>
                                  value == null ? context.strings.select : null,
                            ),
                      SizedBox(height: AppSizes.md),
                      Text(
                        context.strings.amount,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(height: AppSizes.md),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        inputFormatters: [CurrencyInputFormatter()],
                        decoration: const InputDecoration(prefixText: 'Rp '),
                        validator: (v) {
                          final parsed = CurrencyInputFormatter.parse(
                            v ?? '',
                          );
                          if (parsed <= 0) {
                            return context.strings.amount;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.md),
                      Text(
                        context.strings.notes,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(height: AppSizes.md),
                      TextFormField(
                        controller: _noteController,
                        maxLines: 2,
                      ),
                      SizedBox(height: AppSizes.md),
                      Text(
                        context.strings.date,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(height: AppSizes.md),
                      InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(),
                          child: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.md),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : _onSave,
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(context.strings.save),
                        ),
                      ),
                      SizedBox(height: AppSizes.lg),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
        ),
      ),
    );
  }
}
