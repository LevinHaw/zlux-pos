// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionViewModelHash() =>
    r'99e413ed8b07ff3ac7543dffa84522105c347fb0';

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

abstract class _$TransactionViewModel
    extends BuildlessAutoDisposeAsyncNotifier<TransactionState> {
  late final String? orderId;

  FutureOr<TransactionState> build(String? orderId);
}

/// See also [TransactionViewModel].
@ProviderFor(TransactionViewModel)
const transactionViewModelProvider = TransactionViewModelFamily();

/// See also [TransactionViewModel].
class TransactionViewModelFamily extends Family<AsyncValue<TransactionState>> {
  /// See also [TransactionViewModel].
  const TransactionViewModelFamily();

  /// See also [TransactionViewModel].
  TransactionViewModelProvider call(String? orderId) {
    return TransactionViewModelProvider(orderId);
  }

  @override
  TransactionViewModelProvider getProviderOverride(
    covariant TransactionViewModelProvider provider,
  ) {
    return call(provider.orderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionViewModelProvider';
}

/// See also [TransactionViewModel].
class TransactionViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TransactionViewModel,
          TransactionState
        > {
  /// See also [TransactionViewModel].
  TransactionViewModelProvider(String? orderId)
    : this._internal(
        () => TransactionViewModel()..orderId = orderId,
        from: transactionViewModelProvider,
        name: r'transactionViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$transactionViewModelHash,
        dependencies: TransactionViewModelFamily._dependencies,
        allTransitiveDependencies:
            TransactionViewModelFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  TransactionViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String? orderId;

  @override
  FutureOr<TransactionState> runNotifierBuild(
    covariant TransactionViewModel notifier,
  ) {
    return notifier.build(orderId);
  }

  @override
  Override overrideWith(TransactionViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionViewModelProvider._internal(
        () => create()..orderId = orderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    TransactionViewModel,
    TransactionState
  >
  createElement() {
    return _TransactionViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionViewModelProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<TransactionState> {
  /// The parameter `orderId` of this provider.
  String? get orderId;
}

class _TransactionViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TransactionViewModel,
          TransactionState
        >
    with TransactionViewModelRef {
  _TransactionViewModelProviderElement(super.provider);

  @override
  String? get orderId => (origin as TransactionViewModelProvider).orderId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
