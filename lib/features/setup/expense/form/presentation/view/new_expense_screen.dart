import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_size.dart';
import '../viewmodel/new_expense_viewmodel.dart';

class NewExpenseScreen extends ConsumerStatefulWidget {
  final String? expenseId;

  const NewExpenseScreen({super.key, this.expenseId});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NewExpenseScreenState();
  }
}

class _NewExpenseScreenState extends ConsumerState<NewExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(newExpenseViewModelProvider(widget.expenseId).notifier)
        .save(name: _nameController.text);

    if (!mounted) return;
    final state =
        ref.read(newExpenseViewModelProvider(widget.expenseId)).valueOrNull;

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
    final asyncState = ref.watch(newExpenseViewModelProvider(widget.expenseId));

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(context.strings.expense),
      ),
      body: SafeArea(
        child: asyncState.when(
          data: (state) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
                children: [
                  SizedBox(height: AppSizes.lg),
                  Text(
                    context.strings.otherExpenseName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _nameController,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? context.strings.otherIncomeName
                                : null,
                  ),
                  SizedBox(height: AppSizes.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _onSave,
                      child:
                          state.isLoading
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
        ),
      ),
    );
  } 
}