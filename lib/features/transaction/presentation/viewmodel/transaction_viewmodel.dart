import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/order/presentation/order_provider.dart';
import 'package:zlux_pos/features/setup/product/domain/entities/product_entity.dart';
import 'package:zlux_pos/features/setup/product/presentation/provider/product_provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/result.dart';
import '../../../order/domain/entities/order_item_entity.dart';
import '../../../order/domain/entities/payment_method.dart';

part 'transaction_viewmodel.g.dart';

class TransactionState {
  final Map<String, List<ProductEntity>> productsByCategory;
  final Map<String, int> quantities;
  final String notes;
  final PaymentMethod paymentMethod;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const TransactionState({
    this.productsByCategory = const {},
    this.quantities = const {},
    this.notes = '',
    this.paymentMethod = PaymentMethod.cash,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  double get total {
    double sum = 0;
    for (final products in productsByCategory.values) {
      for (final product in products) {
        final qty = quantities[product.id] ?? 0;
        sum += qty * product.price;
      }
    }
    return sum;
  }

  TransactionState copyWith({
    Map<String, List<ProductEntity>>? productsByCategory,
    Map<String, int>? quantities,
    String? notes,
    PaymentMethod? paymentMethod,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return TransactionState(
      productsByCategory: productsByCategory ?? this.productsByCategory,
      quantities: quantities ?? this.quantities,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class TransactionViewModel extends _$TransactionViewModel {

  @override
  Future<TransactionState> build(String? orderId) async {
    final products = await ref.watch(watchProductsUsecaseProvider)().first;

    final grouped = <String, List<ProductEntity>>{};
    for (final product in products) {
      grouped.putIfAbsent(product.category, () => []).add(product);
    }

    if (orderId == null) {
      return TransactionState(productsByCategory: grouped);
    }

    final order = await ref.watch(getOrderByIdUsecaseProvider)(orderId);
    if (order == null) {
      return TransactionState(productsByCategory: grouped);
    }

    final quantities = <String, int>{
      for (final item in order.items)
        if (item.productId.isNotEmpty) item.productId: item.quantity,
    };

    return TransactionState(
      productsByCategory: grouped,
      quantities: quantities,
      notes: order.notes,
      paymentMethod: order.paymentMethod,
    );
  }

  void setNotes(String notes) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(notes: notes));
  }

  void increment(String productId) {
    final current = state.valueOrNull;
    if (current == null) return;
    _setQuantity(current, productId, (current.quantities[productId] ?? 0) + 1);
  }

  void decrement(String productId) {
    final current = state.valueOrNull;
    if (current == null) return;
    final qty = (current.quantities[productId] ?? 0) - 1;
    _setQuantity(current, productId, qty < 0 ? 0 : qty);
  }

  void _setQuantity(TransactionState current, String productId, int qty) {
    final updated = Map<String, int>.from(current.quantities);
    if (qty <= 0) {
      updated.remove(productId);
    } else {
      updated[productId] = qty;
    }
    state = AsyncData(current.copyWith(quantities: updated));
  }

  void setPaymentMethod(PaymentMethod method) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(paymentMethod: method));
  }

  Future<void> checkout() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final items = <OrderItemEntity>[];
    for (final products in current.productsByCategory.values) {
      for (final product in products) {
        final qty = current.quantities[product.id] ?? 0;
        if (qty > 0) {
          items.add(
            OrderItemEntity(
              id: product.id,
              productId: product.id,
              name: product.name,
              quantity: qty,
              price: product.price,
            ),
          );
        }
      }
    }

    if (items.isEmpty) {
      state = AsyncData(
        current.copyWith(errorMessage: AppStrings.select),
      );
      return;
    }

    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));

    final result = orderId == null
        ? await ref.read(createOrderUsecaseProvider)(
            items: items,
            paymentMethod: current.paymentMethod,
            notes: current.notes,
          )
        : await ref.read(updateOrderUsecaseProvider)(
            orderId: orderId!,
            items: items,
            paymentMethod: current.paymentMethod,
            notes: current.notes,
          );

    switch (result) {
      case Success():
        state = AsyncData(
          current.copyWith(
            isLoading: false,
            isSaved: true,
            quantities: orderId == null ? {} : current.quantities,
          ),
        );
      case ResultFailure(:final failure):
        state = AsyncData(
          current.copyWith(isLoading: false, errorMessage: failure.message),
        );
    }
  }
}
