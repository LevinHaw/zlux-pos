// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_income_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newIncomeViewModelHash() =>
    r'2b4febda119bc61eeac9e77461bb368e48d8dc79';

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

abstract class _$NewIncomeViewModel
    extends BuildlessAutoDisposeAsyncNotifier<NewIncomeState> {
  late final String? incomeId;

  FutureOr<NewIncomeState> build(String? incomeId);
}

/// See also [NewIncomeViewModel].
@ProviderFor(NewIncomeViewModel)
const newIncomeViewModelProvider = NewIncomeViewModelFamily();

/// See also [NewIncomeViewModel].
class NewIncomeViewModelFamily extends Family<AsyncValue<NewIncomeState>> {
  /// See also [NewIncomeViewModel].
  const NewIncomeViewModelFamily();

  /// See also [NewIncomeViewModel].
  NewIncomeViewModelProvider call(String? incomeId) {
    return NewIncomeViewModelProvider(incomeId);
  }

  @override
  NewIncomeViewModelProvider getProviderOverride(
    covariant NewIncomeViewModelProvider provider,
  ) {
    return call(provider.incomeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'newIncomeViewModelProvider';
}

/// See also [NewIncomeViewModel].
class NewIncomeViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          NewIncomeViewModel,
          NewIncomeState
        > {
  /// See also [NewIncomeViewModel].
  NewIncomeViewModelProvider(String? incomeId)
    : this._internal(
        () => NewIncomeViewModel()..incomeId = incomeId,
        from: newIncomeViewModelProvider,
        name: r'newIncomeViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$newIncomeViewModelHash,
        dependencies: NewIncomeViewModelFamily._dependencies,
        allTransitiveDependencies:
            NewIncomeViewModelFamily._allTransitiveDependencies,
        incomeId: incomeId,
      );

  NewIncomeViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.incomeId,
  }) : super.internal();

  final String? incomeId;

  @override
  FutureOr<NewIncomeState> runNotifierBuild(
    covariant NewIncomeViewModel notifier,
  ) {
    return notifier.build(incomeId);
  }

  @override
  Override overrideWith(NewIncomeViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: NewIncomeViewModelProvider._internal(
        () => create()..incomeId = incomeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        incomeId: incomeId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NewIncomeViewModel, NewIncomeState>
  createElement() {
    return _NewIncomeViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewIncomeViewModelProvider && other.incomeId == incomeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, incomeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NewIncomeViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<NewIncomeState> {
  /// The parameter `incomeId` of this provider.
  String? get incomeId;
}

class _NewIncomeViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          NewIncomeViewModel,
          NewIncomeState
        >
    with NewIncomeViewModelRef {
  _NewIncomeViewModelProviderElement(super.provider);

  @override
  String? get incomeId => (origin as NewIncomeViewModelProvider).incomeId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
