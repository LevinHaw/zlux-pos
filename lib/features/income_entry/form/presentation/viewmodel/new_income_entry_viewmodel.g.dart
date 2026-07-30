// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_income_entry_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newIncomeEntryViewModelHash() =>
    r'9d7faadc396d20c0e2ce58a7040944821821576c';

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

abstract class _$NewIncomeEntryViewModel
    extends BuildlessAutoDisposeAsyncNotifier<NewIncomeEntryState> {
  late final String? entryId;

  FutureOr<NewIncomeEntryState> build(String? entryId);
}

/// See also [NewIncomeEntryViewModel].
@ProviderFor(NewIncomeEntryViewModel)
const newIncomeEntryViewModelProvider = NewIncomeEntryViewModelFamily();

/// See also [NewIncomeEntryViewModel].
class NewIncomeEntryViewModelFamily
    extends Family<AsyncValue<NewIncomeEntryState>> {
  /// See also [NewIncomeEntryViewModel].
  const NewIncomeEntryViewModelFamily();

  /// See also [NewIncomeEntryViewModel].
  NewIncomeEntryViewModelProvider call(String? entryId) {
    return NewIncomeEntryViewModelProvider(entryId);
  }

  @override
  NewIncomeEntryViewModelProvider getProviderOverride(
    covariant NewIncomeEntryViewModelProvider provider,
  ) {
    return call(provider.entryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'newIncomeEntryViewModelProvider';
}

/// See also [NewIncomeEntryViewModel].
class NewIncomeEntryViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          NewIncomeEntryViewModel,
          NewIncomeEntryState
        > {
  /// See also [NewIncomeEntryViewModel].
  NewIncomeEntryViewModelProvider(String? entryId)
    : this._internal(
        () => NewIncomeEntryViewModel()..entryId = entryId,
        from: newIncomeEntryViewModelProvider,
        name: r'newIncomeEntryViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$newIncomeEntryViewModelHash,
        dependencies: NewIncomeEntryViewModelFamily._dependencies,
        allTransitiveDependencies:
            NewIncomeEntryViewModelFamily._allTransitiveDependencies,
        entryId: entryId,
      );

  NewIncomeEntryViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entryId,
  }) : super.internal();

  final String? entryId;

  @override
  FutureOr<NewIncomeEntryState> runNotifierBuild(
    covariant NewIncomeEntryViewModel notifier,
  ) {
    return notifier.build(entryId);
  }

  @override
  Override overrideWith(NewIncomeEntryViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: NewIncomeEntryViewModelProvider._internal(
        () => create()..entryId = entryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entryId: entryId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    NewIncomeEntryViewModel,
    NewIncomeEntryState
  >
  createElement() {
    return _NewIncomeEntryViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewIncomeEntryViewModelProvider && other.entryId == entryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NewIncomeEntryViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<NewIncomeEntryState> {
  /// The parameter `entryId` of this provider.
  String? get entryId;
}

class _NewIncomeEntryViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          NewIncomeEntryViewModel,
          NewIncomeEntryState
        >
    with NewIncomeEntryViewModelRef {
  _NewIncomeEntryViewModelProviderElement(super.provider);

  @override
  String? get entryId => (origin as NewIncomeEntryViewModelProvider).entryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
