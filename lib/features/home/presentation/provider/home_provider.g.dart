// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$computeDashboardStatsUsecaseHash() =>
    r'42217c6901f0949b42b0fdb8bd9fa82c66dad22f';

/// See also [computeDashboardStatsUsecase].
@ProviderFor(computeDashboardStatsUsecase)
final computeDashboardStatsUsecaseProvider =
    AutoDisposeProvider<ComputeDashboardStatsUsecase>.internal(
      computeDashboardStatsUsecase,
      name: r'computeDashboardStatsUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$computeDashboardStatsUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ComputeDashboardStatsUsecaseRef =
    AutoDisposeProviderRef<ComputeDashboardStatsUsecase>;
String _$computeDailyReportUsecaseHash() =>
    r'7af2b0139456fc5f36434d8b4976e5a7e1b824d5';

/// See also [computeDailyReportUsecase].
@ProviderFor(computeDailyReportUsecase)
final computeDailyReportUsecaseProvider =
    AutoDisposeProvider<ComputeDailyReportUsecase>.internal(
      computeDailyReportUsecase,
      name: r'computeDailyReportUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$computeDailyReportUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ComputeDailyReportUsecaseRef =
    AutoDisposeProviderRef<ComputeDailyReportUsecase>;
String _$watchDailyReportUsecaseHash() =>
    r'270588fc1a4f735d58c51d7bf4d43da07bef7c19';

/// See also [watchDailyReportUsecase].
@ProviderFor(watchDailyReportUsecase)
final watchDailyReportUsecaseProvider =
    AutoDisposeProvider<WatchDailyReportUsecase>.internal(
      watchDailyReportUsecase,
      name: r'watchDailyReportUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$watchDailyReportUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WatchDailyReportUsecaseRef =
    AutoDisposeProviderRef<WatchDailyReportUsecase>;
String _$dailyReportHash() => r'33bd4cbcdab37e63157cb91251fcd665542cf3a8';

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

/// See also [dailyReport].
@ProviderFor(dailyReport)
const dailyReportProvider = DailyReportFamily();

/// See also [dailyReport].
class DailyReportFamily extends Family<AsyncValue<DailyReportEntity>> {
  /// See also [dailyReport].
  const DailyReportFamily();

  /// See also [dailyReport].
  DailyReportProvider call(DateTime date) {
    return DailyReportProvider(date);
  }

  @override
  DailyReportProvider getProviderOverride(
    covariant DailyReportProvider provider,
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
  String? get name => r'dailyReportProvider';
}

/// See also [dailyReport].
class DailyReportProvider extends AutoDisposeStreamProvider<DailyReportEntity> {
  /// See also [dailyReport].
  DailyReportProvider(DateTime date)
    : this._internal(
        (ref) => dailyReport(ref as DailyReportRef, date),
        from: dailyReportProvider,
        name: r'dailyReportProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$dailyReportHash,
        dependencies: DailyReportFamily._dependencies,
        allTransitiveDependencies: DailyReportFamily._allTransitiveDependencies,
        date: date,
      );

  DailyReportProvider._internal(
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
  Override overrideWith(
    Stream<DailyReportEntity> Function(DailyReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyReportProvider._internal(
        (ref) => create(ref as DailyReportRef),
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
  AutoDisposeStreamProviderElement<DailyReportEntity> createElement() {
    return _DailyReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyReportProvider && other.date == date;
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
mixin DailyReportRef on AutoDisposeStreamProviderRef<DailyReportEntity> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DailyReportProviderElement
    extends AutoDisposeStreamProviderElement<DailyReportEntity>
    with DailyReportRef {
  _DailyReportProviderElement(super.provider);

  @override
  DateTime get date => (origin as DailyReportProvider).date;
}

String _$merchantProfileHash() => r'3ae6e2463a68ff5a8762c1e177365c016d665867';

/// See also [merchantProfile].
@ProviderFor(merchantProfile)
final merchantProfileProvider =
    AutoDisposeFutureProvider<MerchantEntity?>.internal(
      merchantProfile,
      name: r'merchantProfileProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$merchantProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MerchantProfileRef = AutoDisposeFutureProviderRef<MerchantEntity?>;
String _$homeDashboardStatsHash() =>
    r'd118e1bca1ce0fe15c0e9afa2f0271d46472dfc5';

/// See also [homeDashboardStats].
@ProviderFor(homeDashboardStats)
final homeDashboardStatsProvider =
    AutoDisposeStreamProvider<DashboardStatsEntity>.internal(
      homeDashboardStats,
      name: r'homeDashboardStatsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$homeDashboardStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeDashboardStatsRef =
    AutoDisposeStreamProviderRef<DashboardStatsEntity>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
