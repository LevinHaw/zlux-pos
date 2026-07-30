// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_expense_entry_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newExpenseEntryViewModelHash() =>
    r'9755dd2614e0754e351d28fd39376ae17edfa344';

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

abstract class _$NewExpenseEntryViewModel
    extends BuildlessAutoDisposeAsyncNotifier<NewExpenseEntryState> {
  late final String? entryId;

  FutureOr<NewExpenseEntryState> build(String? entryId);
}

/// See also [NewExpenseEntryViewModel].
@ProviderFor(NewExpenseEntryViewModel)
const newExpenseEntryViewModelProvider = NewExpenseEntryViewModelFamily();

/// See also [NewExpenseEntryViewModel].
class NewExpenseEntryViewModelFamily
    extends Family<AsyncValue<NewExpenseEntryState>> {
  /// See also [NewExpenseEntryViewModel].
  const NewExpenseEntryViewModelFamily();

  /// See also [NewExpenseEntryViewModel].
  NewExpenseEntryViewModelProvider call(String? entryId) {
    return NewExpenseEntryViewModelProvider(entryId);
  }

  @override
  NewExpenseEntryViewModelProvider getProviderOverride(
    covariant NewExpenseEntryViewModelProvider provider,
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
  String? get name => r'newExpenseEntryViewModelProvider';
}

/// See also [NewExpenseEntryViewModel].
class NewExpenseEntryViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          NewExpenseEntryViewModel,
          NewExpenseEntryState
        > {
  /// See also [NewExpenseEntryViewModel].
  NewExpenseEntryViewModelProvider(String? entryId)
    : this._internal(
        () => NewExpenseEntryViewModel()..entryId = entryId,
        from: newExpenseEntryViewModelProvider,
        name: r'newExpenseEntryViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$newExpenseEntryViewModelHash,
        dependencies: NewExpenseEntryViewModelFamily._dependencies,
        allTransitiveDependencies:
            NewExpenseEntryViewModelFamily._allTransitiveDependencies,
        entryId: entryId,
      );

  NewExpenseEntryViewModelProvider._internal(
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
  FutureOr<NewExpenseEntryState> runNotifierBuild(
    covariant NewExpenseEntryViewModel notifier,
  ) {
    return notifier.build(entryId);
  }

  @override
  Override overrideWith(NewExpenseEntryViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: NewExpenseEntryViewModelProvider._internal(
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
    NewExpenseEntryViewModel,
    NewExpenseEntryState
  >
  createElement() {
    return _NewExpenseEntryViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewExpenseEntryViewModelProvider &&
        other.entryId == entryId;
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
mixin NewExpenseEntryViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<NewExpenseEntryState> {
  /// The parameter `entryId` of this provider.
  String? get entryId;
}

class _NewExpenseEntryViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          NewExpenseEntryViewModel,
          NewExpenseEntryState
        >
    with NewExpenseEntryViewModelRef {
  _NewExpenseEntryViewModelProviderElement(super.provider);

  @override
  String? get entryId => (origin as NewExpenseEntryViewModelProvider).entryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
