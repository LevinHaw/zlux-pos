import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/setup/product/presentation/provider/product_provider.dart';

import '../../../domain/entities/product_entity.dart';

part 'product_list_viewmodel.g.dart';

@riverpod
class ProductListViewModel extends _$ProductListViewModel {
  @override
  Stream<List<ProductEntity>> build() {
    return ref.watch(watchProductsUsecaseProvider)();
  }
}
