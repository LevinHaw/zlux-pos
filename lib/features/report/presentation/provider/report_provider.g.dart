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

String _$dailyReportNoteLocalDataSourceHash() =>
    r'6aaa2700800250ac55a0fd7fc26b0114c9b368e9';

/// See also [dailyReportNoteLocalDataSource].
@ProviderFor(dailyReportNoteLocalDataSource)
final dailyReportNoteLocalDataSourceProvider =
    AutoDisposeProvider<DailyReportNoteLocalDatasource>.internal(
      dailyReportNoteLocalDataSource,
      name: r'dailyReportNoteLocalDataSourceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$dailyReportNoteLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyReportNoteLocalDataSourceRef =
    AutoDisposeProviderRef<DailyReportNoteLocalDatasource>;
String _$dailyReportNoteRemoteDataSourceHash() =>
    r'bb317566ed836fc0793d0f3dea3ecd87bf6431b1';

/// See also [dailyReportNoteRemoteDataSource].
@ProviderFor(dailyReportNoteRemoteDataSource)
final dailyReportNoteRemoteDataSourceProvider =
    AutoDisposeProvider<DailyReportNoteRemoteDatasource>.internal(
      dailyReportNoteRemoteDataSource,
      name: r'dailyReportNoteRemoteDataSourceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$dailyReportNoteRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyReportNoteRemoteDataSourceRef =
    AutoDisposeProviderRef<DailyReportNoteRemoteDatasource>;
String _$dailyReportNoteRepositoryHash() =>
    r'c235a4a827a2735ef073dd3ecf45c1ec6000dfc5';

/// See also [dailyReportNoteRepository].
@ProviderFor(dailyReportNoteRepository)
final dailyReportNoteRepositoryProvider =
    AutoDisposeProvider<DailyReportNoteRepository>.internal(
      dailyReportNoteRepository,
      name: r'dailyReportNoteRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$dailyReportNoteRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyReportNoteRepositoryRef =
    AutoDisposeProviderRef<DailyReportNoteRepository>;
String _$saveDailyReportNoteUsecaseHash() =>
    r'b743719b2a4ec7e056ec6395a8301fb5cd762b54';

/// See also [saveDailyReportNoteUsecase].
@ProviderFor(saveDailyReportNoteUsecase)
final saveDailyReportNoteUsecaseProvider =
    AutoDisposeProvider<SaveDailyReportNoteUsecase>.internal(
      saveDailyReportNoteUsecase,
      name: r'saveDailyReportNoteUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$saveDailyReportNoteUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SaveDailyReportNoteUsecaseRef =
    AutoDisposeProviderRef<SaveDailyReportNoteUsecase>;
String _$watchDailyReportNoteUsecaseHash() =>
    r'85c00326b2ccf3e082e7887be53c265e5ce6eee2';

/// See also [watchDailyReportNoteUsecase].
@ProviderFor(watchDailyReportNoteUsecase)
final watchDailyReportNoteUsecaseProvider =
    AutoDisposeProvider<WatchDailyReportNoteUsecase>.internal(
      watchDailyReportNoteUsecase,
      name: r'watchDailyReportNoteUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$watchDailyReportNoteUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WatchDailyReportNoteUsecaseRef =
    AutoDisposeProviderRef<WatchDailyReportNoteUsecase>;
String _$pullDailyReportNotesUsecaseHash() =>
    r'25d4db73b52b1caaa45bcf1d9a7b85d094c6ad92';

/// See also [pullDailyReportNotesUsecase].
@ProviderFor(pullDailyReportNotesUsecase)
final pullDailyReportNotesUsecaseProvider =
    AutoDisposeProvider<PullDailyReportNotesUsecase>.internal(
      pullDailyReportNotesUsecase,
      name: r'pullDailyReportNotesUsecaseProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$pullDailyReportNotesUsecaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PullDailyReportNotesUsecaseRef =
    AutoDisposeProviderRef<PullDailyReportNotesUsecase>;
String _$dailyReportNoteHash() => r'631176c37cc61a2b2e88396bd385c3c6ed2fe73a';

/// See also [dailyReportNote].
@ProviderFor(dailyReportNote)
const dailyReportNoteProvider = DailyReportNoteFamily();

/// See also [dailyReportNote].
class DailyReportNoteFamily extends Family<AsyncValue<DailyReportNoteEntity?>> {
  /// See also [dailyReportNote].
  const DailyReportNoteFamily();

  /// See also [dailyReportNote].
  DailyReportNoteProvider call(DateTime date) {
    return DailyReportNoteProvider(date);
  }

  @override
  DailyReportNoteProvider getProviderOverride(
    covariant DailyReportNoteProvider provider,
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
  String? get name => r'dailyReportNoteProvider';
}

/// See also [dailyReportNote].
class DailyReportNoteProvider
    extends AutoDisposeStreamProvider<DailyReportNoteEntity?> {
  /// See also [dailyReportNote].
  DailyReportNoteProvider(DateTime date)
    : this._internal(
        (ref) => dailyReportNote(ref as DailyReportNoteRef, date),
        from: dailyReportNoteProvider,
        name: r'dailyReportNoteProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$dailyReportNoteHash,
        dependencies: DailyReportNoteFamily._dependencies,
        allTransitiveDependencies:
            DailyReportNoteFamily._allTransitiveDependencies,
        date: date,
      );

  DailyReportNoteProvider._internal(
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
    Stream<DailyReportNoteEntity?> Function(DailyReportNoteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyReportNoteProvider._internal(
        (ref) => create(ref as DailyReportNoteRef),
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
  AutoDisposeStreamProviderElement<DailyReportNoteEntity?> createElement() {
    return _DailyReportNoteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyReportNoteProvider && other.date == date;
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
mixin DailyReportNoteRef
    on AutoDisposeStreamProviderRef<DailyReportNoteEntity?> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DailyReportNoteProviderElement
    extends AutoDisposeStreamProviderElement<DailyReportNoteEntity?>
    with DailyReportNoteRef {
  _DailyReportNoteProviderElement(super.provider);

  @override
  DateTime get date => (origin as DailyReportNoteProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
