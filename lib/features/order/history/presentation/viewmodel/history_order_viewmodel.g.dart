// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_order_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$historyOrderViewModelHash() =>
    r'f103ed0824dae875e10c3ca6bdf2e4b617e0f322';

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

abstract class _$HistoryOrderViewModel
    extends BuildlessAutoDisposeStreamNotifier<List<OrderEntity>> {
  late final DateTime date;

  Stream<List<OrderEntity>> build(DateTime date);
}

/// See also [HistoryOrderViewModel].
@ProviderFor(HistoryOrderViewModel)
const historyOrderViewModelProvider = HistoryOrderViewModelFamily();

/// See also [HistoryOrderViewModel].
class HistoryOrderViewModelFamily
    extends Family<AsyncValue<List<OrderEntity>>> {
  /// See also [HistoryOrderViewModel].
  const HistoryOrderViewModelFamily();

  /// See also [HistoryOrderViewModel].
  HistoryOrderViewModelProvider call(DateTime date) {
    return HistoryOrderViewModelProvider(date);
  }

  @override
  HistoryOrderViewModelProvider getProviderOverride(
    covariant HistoryOrderViewModelProvider provider,
  ) {
    return call(provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'historyOrderViewModelProvider';
}

/// See also [HistoryOrderViewModel].
class HistoryOrderViewModelProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<
          HistoryOrderViewModel,
          List<OrderEntity>
        > {
  /// See also [HistoryOrderViewModel].
  HistoryOrderViewModelProvider(DateTime date)
    : this._internal(
        () => HistoryOrderViewModel()..date = date,
        from: historyOrderViewModelProvider,
        name: r'historyOrderViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$historyOrderViewModelHash,
        dependencies: HistoryOrderViewModelFamily._dependencies,
        allTransitiveDependencies:
            HistoryOrderViewModelFamily._allTransitiveDependencies,
        date: date,
      );

  HistoryOrderViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Stream<List<OrderEntity>> runNotifierBuild(
    covariant HistoryOrderViewModel notifier,
  ) {
    return notifier.build(date);
  }

  @override
  Override overrideWith(HistoryOrderViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: HistoryOrderViewModelProvider._internal(
        () => create()..date = date,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<
    HistoryOrderViewModel,
    List<OrderEntity>
  >
  createElement() {
    return _HistoryOrderViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HistoryOrderViewModelProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HistoryOrderViewModelRef
    on AutoDisposeStreamNotifierProviderRef<List<OrderEntity>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _HistoryOrderViewModelProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<
          HistoryOrderViewModel,
          List<OrderEntity>
        >
    with HistoryOrderViewModelRef {
  _HistoryOrderViewModelProviderElement(super.provider);

  @override
  DateTime get date => (origin as HistoryOrderViewModelProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
