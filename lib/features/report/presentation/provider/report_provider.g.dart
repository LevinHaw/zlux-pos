// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyReportPdfServiceHash() =>
    r'21ee3cdc094e04ade63ff5009327eef1a81a0c87';

/// See also [dailyReportPdfService].
@ProviderFor(dailyReportPdfService)
final dailyReportPdfServiceProvider =
    AutoDisposeProvider<DailyReportPdfService>.internal(
      dailyReportPdfService,
      name: r'dailyReportPdfServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$dailyReportPdfServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyReportPdfServiceRef =
    AutoDisposeProviderRef<DailyReportPdfService>;
String _$computeDailyReportDetailUsecaseHash() =>
    r'2ee64785477128b20e14f2375d7b2ea20a7c377c';

/// See also [computeDailyReportDetailUsecase].
@ProviderFor(computeDailyReportDetailUsecase)
final computeDailyReportDetailUsecaseProvider =
    AutoDisposeProvider<ComputeDailyReportDetailUsecase>.internal(
      computeDailyReportDetailUsecase,
      name: r'computeDailyReportDetailUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$computeDailyReportDetailUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ComputeDailyReportDetailUsecaseRef =
    AutoDisposeProviderRef<ComputeDailyReportDetailUsecase>;
String _$watchDailyReportDetailUsecaseHash() =>
    r'065ec67ee7ca167efff1e94f2fd3296e46269bd7';

/// See also [watchDailyReportDetailUsecase].
@ProviderFor(watchDailyReportDetailUsecase)
final watchDailyReportDetailUsecaseProvider =
    AutoDisposeProvider<WatchDailyReportDetailUsecase>.internal(
      watchDailyReportDetailUsecase,
      name: r'watchDailyReportDetailUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$watchDailyReportDetailUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WatchDailyReportDetailUsecaseRef =
    AutoDisposeProviderRef<WatchDailyReportDetailUsecase>;
String _$watchReportDatesUsecaseHash() =>
    r'8e91e1f48cd2ec6d31ad305ebcc22bcfa04c129d';

/// See also [watchReportDatesUsecase].
@ProviderFor(watchReportDatesUsecase)
final watchReportDatesUsecaseProvider =
    AutoDisposeProvider<WatchReportDatesUsecase>.internal(
      watchReportDatesUsecase,
      name: r'watchReportDatesUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$watchReportDatesUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WatchReportDatesUsecaseRef =
    AutoDisposeProviderRef<WatchReportDatesUsecase>;
String _$reportDatesHash() => r'bad4daa7b85cd238cf1b336ce590d20718f182a2';

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

/// See also [reportDates].
@ProviderFor(reportDates)
const reportDatesProvider = ReportDatesFamily();

/// See also [reportDates].
class ReportDatesFamily extends Family<AsyncValue<List<DateTime>>> {
  /// See also [reportDates].
  const ReportDatesFamily();

  /// See also [reportDates].
  ReportDatesProvider call({required int year, required int month}) {
    return ReportDatesProvider(year: year, month: month);
  }

  @override
  ReportDatesProvider getProviderOverride(
    covariant ReportDatesProvider provider,
  ) {
    return call(year: provider.year, month: provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reportDatesProvider';
}

/// See also [reportDates].
class ReportDatesProvider extends AutoDisposeStreamProvider<List<DateTime>> {
  /// See also [reportDates].
  ReportDatesProvider({required int year, required int month})
    : this._internal(
        (ref) => reportDates(ref as ReportDatesRef, year: year, month: month),
        from: reportDatesProvider,
        name: r'reportDatesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$reportDatesHash,
        dependencies: ReportDatesFamily._dependencies,
        allTransitiveDependencies: ReportDatesFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  ReportDatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    Stream<List<DateTime>> Function(ReportDatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportDatesProvider._internal(
        (ref) => create(ref as ReportDatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<DateTime>> createElement() {
    return _ReportDatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportDatesProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReportDatesRef on AutoDisposeStreamProviderRef<List<DateTime>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _ReportDatesProviderElement
    extends AutoDisposeStreamProviderElement<List<DateTime>>
    with ReportDatesRef {
  _ReportDatesProviderElement(super.provider);

  @override
  int get year => (origin as ReportDatesProvider).year;
  @override
  int get month => (origin as ReportDatesProvider).month;
}

String _$dailyReportDetailHash() => r'138d58d1debff107de91ce5eda2b7e0e9e90c68e';

/// See also [dailyReportDetail].
@ProviderFor(dailyReportDetail)
const dailyReportDetailProvider = DailyReportDetailFamily();

/// See also [dailyReportDetail].
class DailyReportDetailFamily
    extends Family<AsyncValue<DailyReportDetailEntity>> {
  /// See also [dailyReportDetail].
  const DailyReportDetailFamily();

  /// See also [dailyReportDetail].
  DailyReportDetailProvider call(DateTime date) {
    return DailyReportDetailProvider(date);
  }

  @override
  DailyReportDetailProvider getProviderOverride(
    covariant DailyReportDetailProvider provider,
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
  String? get name => r'dailyReportDetailProvider';
}

/// See also [dailyReportDetail].
class DailyReportDetailProvider
    extends AutoDisposeStreamProvider<DailyReportDetailEntity> {
  /// See also [dailyReportDetail].
  DailyReportDetailProvider(DateTime date)
    : this._internal(
        (ref) => dailyReportDetail(ref as DailyReportDetailRef, date),
        from: dailyReportDetailProvider,
        name: r'dailyReportDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$dailyReportDetailHash,
        dependencies: DailyReportDetailFamily._dependencies,
        allTransitiveDependencies:
            DailyReportDetailFamily._allTransitiveDependencies,
        date: date,
      );

  DailyReportDetailProvider._internal(
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
    Stream<DailyReportDetailEntity> Function(DailyReportDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyReportDetailProvider._internal(
        (ref) => create(ref as DailyReportDetailRef),
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
  AutoDisposeStreamProviderElement<DailyReportDetailEntity> createElement() {
    return _DailyReportDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyReportDetailProvider && other.date == date;
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
mixin DailyReportDetailRef
    on AutoDisposeStreamProviderRef<DailyReportDetailEntity> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DailyReportDetailProviderElement
    extends AutoDisposeStreamProviderElement<DailyReportDetailEntity>
    with DailyReportDetailRef {
  _DailyReportDetailProviderElement(super.provider);

  @override
  DateTime get date => (origin as DailyReportDetailProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
