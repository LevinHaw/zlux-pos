import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/utils/result.dart';
import 'package:zlux_pos/features/setup/product/presentation/provider/product_provider.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/product_entity.dart';

part 'product_form_viewmodel.g.dart';

class ProductFormState {
  final ProductEntity? initial;
  final List<CategoryEntity> categories;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const ProductFormState({
    this.initial,
    this.categories = const [],
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  bool get isEditing => initial != null;

  ProductFormState copyWith({
    ProductEntity? initial,
    List<CategoryEntity>? categories,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return ProductFormState(
      initial: initial ?? this.initial,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class ProductFormViewModel extends _$ProductFormViewModel {
  @override
  Future<ProductFormState> build(String? productId) async {
    ProductEntity? initial;
    if (productId != null) {
      final repository = ref.watch(productRepositoryProvider);
      initial = await repository.getProduct(productId);
    }

    final categories = await ref.watch(watchCategoriesUsecaseProvider)().first;

    return ProductFormState(initial: initial, categories: categories);
  }

  Future<void> addCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final usecase = ref.read(addCategoryUsecaseProvider);
    final result = await usecase(trimmed);
    final current = state.valueOrNull ?? const ProductFormState();

    switch (result) {
      case Success(:final data):
        state = AsyncData(
          current.copyWith(categories: [...current.categories, data]),
        );
      case ResultFailure(:final failure):
        state = AsyncData(current.copyWith(errorMessage: failure.message));
    }
  }

  Future<void> save({
    required String name,
    required double price,
    required String category,
  }) async {
    final current = state.valueOrNull ?? const ProductFormState();
    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));

    final usecase = ref.read(saveProductUsecaseProvider);
    final result = await usecase(
      id: current.initial?.id,
      name: name.trim(),
      price: price,
      category: category,
    );

    switch (result) {
      case Success():
        state = AsyncData(current.copyWith(isLoading: false, isSaved: true));
      case ResultFailure(:final failure):
        state = AsyncData(
          current.copyWith(isLoading: false, errorMessage: failure.message),
        );
    }
  }
}
