// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_form_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productFormViewModelHash() =>
    r'd1a543830f6b0f2dacf926908201d3fe2deb298b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ProductFormViewModel
    extends BuildlessAutoDisposeAsyncNotifier<ProductFormState> {
  late final String? productId;

  FutureOr<ProductFormState> build(String? productId);
}

/// See also [ProductFormViewModel].
@ProviderFor(ProductFormViewModel)
const productFormViewModelProvider = ProductFormViewModelFamily();

/// See also [ProductFormViewModel].
class ProductFormViewModelFamily extends Family<AsyncValue<ProductFormState>> {
  /// See also [ProductFormViewModel].
  const ProductFormViewModelFamily();

  /// See also [ProductFormViewModel].
  ProductFormViewModelProvider call(String? productId) {
    return ProductFormViewModelProvider(productId);
  }

  @override
  ProductFormViewModelProvider getProviderOverride(
    covariant ProductFormViewModelProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productFormViewModelProvider';
}

/// See also [ProductFormViewModel].
class ProductFormViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProductFormViewModel,
          ProductFormState
        > {
  /// See also [ProductFormViewModel].
  ProductFormViewModelProvider(String? productId)
    : this._internal(
        () => ProductFormViewModel()..productId = productId,
        from: productFormViewModelProvider,
        name: r'productFormViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productFormViewModelHash,
        dependencies: ProductFormViewModelFamily._dependencies,
        allTransitiveDependencies:
            ProductFormViewModelFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductFormViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String? productId;

  @override
  FutureOr<ProductFormState> runNotifierBuild(
    covariant ProductFormViewModel notifier,
  ) {
    return notifier.build(productId);
  }

  @override
  Override overrideWith(ProductFormViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductFormViewModelProvider._internal(
        () => create()..productId = productId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ProductFormViewModel,
    ProductFormState
  >
  createElement() {
    return _ProductFormViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductFormViewModelProvider &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductFormViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<ProductFormState> {
  /// The parameter `productId` of this provider.
  String? get productId;
}

class _ProductFormViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProductFormViewModel,
          ProductFormState
        >
    with ProductFormViewModelRef {
  _ProductFormViewModelProviderElement(super.provider);

  @override
  String? get productId => (origin as ProductFormViewModelProvider).productId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
