// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_expense_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newExpenseViewModelHash() =>
    r'9dfc6cf3acac822a027bcfe63653f22786e323f4';

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

abstract class _$NewExpenseViewModel
    extends BuildlessAutoDisposeAsyncNotifier<NewExpenseState> {
  late final String? expenseId;

  FutureOr<NewExpenseState> build(String? expenseId);
}

/// See also [NewExpenseViewModel].
@ProviderFor(NewExpenseViewModel)
const newExpenseViewModelProvider = NewExpenseViewModelFamily();

/// See also [NewExpenseViewModel].
class NewExpenseViewModelFamily extends Family<AsyncValue<NewExpenseState>> {
  /// See also [NewExpenseViewModel].
  const NewExpenseViewModelFamily();

  /// See also [NewExpenseViewModel].
  NewExpenseViewModelProvider call(String? expenseId) {
    return NewExpenseViewModelProvider(expenseId);
  }

  @override
  NewExpenseViewModelProvider getProviderOverride(
    covariant NewExpenseViewModelProvider provider,
  ) {
    return call(provider.expenseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'newExpenseViewModelProvider';
}

/// See also [NewExpenseViewModel].
class NewExpenseViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          NewExpenseViewModel,
          NewExpenseState
        > {
  /// See also [NewExpenseViewModel].
  NewExpenseViewModelProvider(String? expenseId)
    : this._internal(
        () => NewExpenseViewModel()..expenseId = expenseId,
        from: newExpenseViewModelProvider,
        name: r'newExpenseViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$newExpenseViewModelHash,
        dependencies: NewExpenseViewModelFamily._dependencies,
        allTransitiveDependencies:
            NewExpenseViewModelFamily._allTransitiveDependencies,
        expenseId: expenseId,
      );

  NewExpenseViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.expenseId,
  }) : super.internal();

  final String? expenseId;

  @override
  FutureOr<NewExpenseState> runNotifierBuild(
    covariant NewExpenseViewModel notifier,
  ) {
    return notifier.build(expenseId);
  }

  @override
  Override overrideWith(NewExpenseViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: NewExpenseViewModelProvider._internal(
        () => create()..expenseId = expenseId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        expenseId: expenseId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NewExpenseViewModel, NewExpenseState>
  createElement() {
    return _NewExpenseViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewExpenseViewModelProvider && other.expenseId == expenseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, expenseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NewExpenseViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<NewExpenseState> {
  /// The parameter `expenseId` of this provider.
  String? get expenseId;
}

class _NewExpenseViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          NewExpenseViewModel,
          NewExpenseState
        >
    with NewExpenseViewModelRef {
  _NewExpenseViewModelProviderElement(super.provider);

  @override
  String? get expenseId => (origin as NewExpenseViewModelProvider).expenseId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
