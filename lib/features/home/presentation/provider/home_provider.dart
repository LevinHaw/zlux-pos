import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/home/domain/entities/dashboard_stats_entity.dart';
import 'package:zlux_pos/features/home/domain/usecase/compute_stat_dashboard_usecase.dart';
import 'package:zlux_pos/features/order/presentation/order_provider.dart';
import 'package:zlux_pos/features/setup/presentation/provider/setup_provider.dart';

import '../../../setup/domain/entities/merchant_entity.dart';
import '../../../../core/utils/result.dart';

part 'home_provider.g.dart';

@riverpod
ComputeDashboardStatsUsecase computeDashboardStatsUsecase(
  ComputeDashboardStatsUsecaseRef ref,
) {
  return const ComputeDashboardStatsUsecase();
}

@riverpod
Future<MerchantEntity?> merchantProfile(MerchantProfileRef ref) async {
  final usecase = ref.watch(getMerchantUsecaseProvider);
  final result = await usecase();
  return switch (result) {
    Success(:final data) => data,
    ResultFailure() => null,
  };
}

@riverpod
Stream<DashboardStatsEntity> homeDashboardStats(HomeDashboardStatsRef ref) {
  final ordersUsecase = ref.watch(watchOrdersByDateUsecaseProvider);
  final statsUsecase = ref.watch(computeDashboardStatsUsecaseProvider);
  return ordersUsecase(DateTime.now())
      .map((orders) => statsUsecase(orders));
}
