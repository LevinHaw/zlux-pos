import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zlux_pos/features/order/domain/entities/payment_method.dart';
import 'package:zlux_pos/features/setup/product/domain/entities/product_entity.dart';
import 'package:zlux_pos/features/transaction/presentation/viewmodel/transaction_viewmodel.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';

/// orderId is null for a new transaction (Checkout flow), or set when
/// opened via History Order's Edit button — in which case this screen
/// shows the same UI but pre-filled and saves back to that order.
class TransactionScreen extends ConsumerStatefulWidget {
  final String? orderId;

  const TransactionScreen({super.key, this.orderId});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  final _notesController = TextEditingController();
  bool _notesPrefilled = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.orderId != null;
    final provider = transactionViewModelProvider(widget.orderId);
    final asyncState = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );

    ref.listen(provider, (previous, next) {
      final state = next.valueOrNull;
      if (state == null) return;
      if (state.isSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? context.strings.orderUpdated
                  : context.strings.checkoutSuccess,
            ),
          ),
        );
        Navigator.of(context).pop();
      } else if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          isEditing ? context.strings.editTransaction : context.strings.transaction,
        ),
      ),
      body: asyncState.when(
        data: (state) {
          if (!_notesPrefilled && state.notes.isNotEmpty) {
            _notesController.text = state.notes;
            _notesPrefilled = true;
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
                  children: [
                    for (final entry in state.productsByCategory.entries) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ...entry.value.map(
                        (product) => _ProductRow(
                          product: product,
                          quantity: state.quantities[product.id] ?? 0,
                          onIncrement: () => viewModel.increment(product.id),
                          onDecrement: () => viewModel.decrement(product.id),
                        ),
                      ),
                      SizedBox(height: AppSizes.md),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: context.appColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusMd),
                    topRight: Radius.circular(AppSizes.radiusMd),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: context.strings.notes,
                      ),
                      maxLines: 2,
                      onChanged: viewModel.setNotes,
                    ),
                    SizedBox(height: AppSizes.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.strings.payment,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          context.strings.total,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<PaymentMethod>(
                          value: state.paymentMethod,
                          items: PaymentMethod.values
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(m.label),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.setPaymentMethod(value);
                            }
                          },
                        ),
                        Text(
                          currency.format(state.total),
                          style: TextStyle(
                            color: context.appColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : viewModel.checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.appColors.primary,
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                isEditing
                                    ? context.strings.save
                                    : context.strings.checkout,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _ProductRow({
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.md / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(product.name)),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle, color: context.appColors.primary),
                onPressed: quantity > 0 ? onDecrement : null,
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(
                width: 24,
                child: Text('$quantity', textAlign: TextAlign.center),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: context.appColors.primary),
                onPressed: onIncrement,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}