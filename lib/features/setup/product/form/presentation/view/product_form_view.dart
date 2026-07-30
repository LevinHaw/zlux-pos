import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import 'package:zlux_pos/core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/features/setup/product/form/presentation/viewmodel/product_form_viewmodel.dart';
import 'package:zlux_pos/features/setup/product/domain/entities/category_entity.dart';

import '../../../../../../core/utils/currency_input_formatter.dart';

class ProductFormView extends ConsumerStatefulWidget {
  final String? productId;
  final String title;

  const ProductFormView({
    super.key,
    required this.productId,
    required this.title,
  });

  @override
  ConsumerState<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends ConsumerState<ProductFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategory;
  bool _prefilled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _addCategoryDialog() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.strings.newCategory),
            content: TextField(controller: controller, autofocus: true),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.strings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text(context.strings.save),
              ),
            ],
          ),
    );

    if (name != null && name.trim().isNotEmpty) {
      final trimmed = name.trim();
      final existing =
          ref
              .read(productFormViewModelProvider(widget.productId))
              .valueOrNull
              ?.categories ??
          <CategoryEntity>[];
      final alreadyExists = existing.any(
        (c) => c.name.toLowerCase() == trimmed.toLowerCase(),
      );

      if (!alreadyExists) {
        await ref
            .read(productFormViewModelProvider(widget.productId).notifier)
            .addCategory(trimmed);
      }
      setState(() => _selectedCategory = trimmed);
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.strings.category)));
      return;
    }

    final price = CurrencyInputFormatter.parse(_priceController.text);

    await ref
        .read(productFormViewModelProvider(widget.productId).notifier)
        .save(
          name: _nameController.text,
          price: price,
          category: _selectedCategory!,
        );

    if (!mounted) return;
    final state =
        ref.read(productFormViewModelProvider(widget.productId)).valueOrNull;

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
    final asyncState = ref.watch(
      productFormViewModelProvider(widget.productId),
    );

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: asyncState.when(
          data: (state) {
            if (!_prefilled && state.initial != null) {
              _nameController.text = state.initial!.name;
              _priceController.text = CurrencyInputFormatter.formatValue(
                state.initial!.price,
              );
              _selectedCategory = state.initial!.category;
              _prefilled = true;
            }
            final categoryItems = <String, CategoryEntity>{};
            for (final c in state.categories) {
              categoryItems.putIfAbsent(c.name, () => c);
            }
            final uniqueCategories = categoryItems.values.toList();

            _selectedCategory ??=
                uniqueCategories.isNotEmpty
                    ? uniqueCategories.first.name
                    : null;
            if (_selectedCategory != null &&
                !uniqueCategories.any((c) => c.name == _selectedCategory)) {
              _selectedCategory =
                  uniqueCategories.isNotEmpty
                      ? uniqueCategories.first.name
                      : null;
            }

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
                children: [
                  SizedBox(height: AppSizes.lg),
                  Text(
                    context.strings.productName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _nameController,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? context.strings.productName
                                : null,
                  ),
                  SizedBox(height: AppSizes.md),
                  Text(
                    context.strings.price,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                    ),
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: const InputDecoration(prefixText: 'Rp '),
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? context.strings.price
                                : null,
                  ),
                  SizedBox(height: AppSizes.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.strings.category,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: context.appColors.primary,
                        ),
                        onPressed: _addCategoryDialog,
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items:
                        uniqueCategories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.name,
                                child: Text(c.name),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => _selectedCategory = value),
                  ),
                  SizedBox(height: AppSizes.lg),
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
