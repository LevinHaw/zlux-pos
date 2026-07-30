import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zlux_pos/core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import 'package:zlux_pos/features/income_entry/form/presentation/viewmodel/new_income_entry_viewmodel.dart';
import 'package:zlux_pos/features/setup/income/domain/entities/income_entity.dart';
import 'package:zlux_pos/features/setup/income/presentation/provider/income_provider.dart';

import '../../../../../core/utils/currency_input_formatter.dart';

class NewIncomeEntryScreen extends ConsumerStatefulWidget {
  final String? entryId;
  const NewIncomeEntryScreen({super.key, this.entryId});

  @override
  ConsumerState<NewIncomeEntryScreen> createState() =>
      _NewIncomeEntryScreenState();
}

class _NewIncomeEntryScreenState extends ConsumerState<NewIncomeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedIncomeId;
  DateTime _selectedDate = DateTime.now();
  bool _prefilled = false;
  List<IncomeEntity> _latestOptions = const [];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _prefillIfNeeded(NewIncomeEntryState state, List<IncomeEntity> options) {
    if (_prefilled || state.initial == null) return;
    final initial = state.initial!;
    _amountController.text = CurrencyInputFormatter.formatValue(
      initial.amount,
    );
    _noteController.text = initial.note;
    _selectedDate = initial.date;
    _selectedIncomeId = initial.incomeId;
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
        .where((o) => o.id == _selectedIncomeId)
        .toList();
    if (selected.isEmpty) return;
    final selectedIncome = selected.first;

    final amount = CurrencyInputFormatter.parse(_amountController.text);

    await ref
        .read(newIncomeEntryViewModelProvider(widget.entryId).notifier)
        .save(
          incomeId: selectedIncome.id,
          incomeName: selectedIncome.name,
          amount: amount,
          note: _noteController.text,
          date: _selectedDate,
        );

    if (!mounted) return;
    final state =
        ref.read(newIncomeEntryViewModelProvider(widget.entryId)).valueOrNull;

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
        ref.watch(newIncomeEntryViewModelProvider(widget.entryId));
    final incomeOptionsAsync = ref.watch(watchIncomeUsecaseProvider).call();

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(context.strings.incomeEntry),
      ),
      body: SafeArea(
        child: asyncState.when(
          data: (state) {
            return StreamBuilder<List<IncomeEntity>>(
              stream: incomeOptionsAsync,
              builder: (context, snapshot) {
                final options = snapshot.data ?? const <IncomeEntity>[];
                _latestOptions = options;
                _prefillIfNeeded(state, options);
                final selectedExists =
                    options.any((o) => o.id == _selectedIncomeId);

                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    children: [
                      SizedBox(height: AppSizes.lg),
                      Text(
                        context.strings.incomeCategory,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(height: AppSizes.md),
                      options.isEmpty
                          ? Text(
                              context.strings.emptyIncome,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : DropdownButtonFormField<String>(
                              value: selectedExists ? _selectedIncomeId : null,
                              items: options
                                  .map(
                                    (income) => DropdownMenuItem(
                                      value: income.id,
                                      child: Text(income.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedIncomeId = value),
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
