import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/provider/database_provider.dart';
import 'package:zlux_pos/features/setup/product/data/datasource/category_local_datasource.dart';
import 'package:zlux_pos/features/setup/product/data/datasource/category_remote_datasource.dart';
import 'package:zlux_pos/features/setup/product/data/datasource/product_local_datasource.dart';
import 'package:zlux_pos/features/setup/product/data/datasource/product_remote_datasource.dart';
import 'package:zlux_pos/features/setup/product/data/repository/category_repository_impl.dart';
import 'package:zlux_pos/features/setup/product/data/repository/product_repository_impl.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/category_repository.dart';
import 'package:zlux_pos/features/setup/product/domain/repository/product_repository.dart';
import 'package:zlux_pos/features/setup/product/domain/usecase/add_category_usecase.dart';
import 'package:zlux_pos/features/setup/product/domain/usecase/delete_product_usecase.dart';
import 'package:zlux_pos/features/setup/product/domain/usecase/pull_categories_usecase.dart';
import 'package:zlux_pos/features/setup/product/domain/usecase/pull_product_usecase.dart';
import 'package:zlux_pos/features/setup/product/domain/usecase/save_product_usecase.dart';
import 'package:zlux_pos/features/setup/product/domain/usecase/watch_category_usecase.dart';
import 'package:zlux_pos/features/setup/product/domain/usecase/watch_product_usecase.dart';


part 'product_provider.g.dart';

String _requireUid() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw StateError('User is not authenticated');
  return user.uid;
}

@riverpod
ProductLocalDataSource productLocalDataSource(
  ProductLocalDataSourceRef ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return ProductLocalDataSource(db.productDao);
}

@riverpod
ProductRemoteDataSource productRemoteDataSource(
  ProductRemoteDataSourceRef ref,
) {
  return ProductRemoteDataSource(FirebaseFirestore.instance);
}

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepositoryImpl(
    local: ref.watch(productLocalDataSourceProvider),
    remote: ref.watch(productRemoteDataSourceProvider),
    ownerId: _requireUid,
  );
}

@riverpod
CategoryLocalDataSource categoryLocalDataSource(
  CategoryLocalDataSourceRef ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryLocalDataSource(db.categoryDao);
}

@riverpod
CategoryRemoteDataSource categoryRemoteDataSource(
  CategoryRemoteDataSourceRef ref,
) {
  return CategoryRemoteDataSource(FirebaseFirestore.instance);
}

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepositoryImpl(
    local: ref.watch(categoryLocalDataSourceProvider),
    remote: ref.watch(categoryRemoteDataSourceProvider),
    ownerId: _requireUid,
  );
}

@riverpod
WatchProductsUsecase watchProductsUsecase(WatchProductsUsecaseRef ref) {
  return WatchProductsUsecase(ref.watch(productRepositoryProvider));
}

@riverpod
SaveProductUsecase saveProductUsecase(SaveProductUsecaseRef ref) {
  return SaveProductUsecase(ref.watch(productRepositoryProvider));
}

@riverpod
DeleteProductUsecase deleteProductUsecase(DeleteProductUsecaseRef ref) {
  return DeleteProductUsecase(ref.watch(productRepositoryProvider));
}

@riverpod
PullProductsUsecase pullProductsUsecase(PullProductsUsecaseRef ref) {
  return PullProductsUsecase(ref.watch(productRepositoryProvider));
}

@riverpod
WatchCategoriesUsecase watchCategoriesUsecase(
  WatchCategoriesUsecaseRef ref,
) {
  return WatchCategoriesUsecase(ref.watch(categoryRepositoryProvider));
}

@riverpod
AddCategoryUsecase addCategoryUsecase(AddCategoryUsecaseRef ref) {
  return AddCategoryUsecase(ref.watch(categoryRepositoryProvider));
}

@riverpod
PullCategoriesUsecase pullCategoriesUsecase(PullCategoriesUsecaseRef ref) {
  return PullCategoriesUsecase(ref.watch(categoryRepositoryProvider));
}