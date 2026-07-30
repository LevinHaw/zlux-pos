import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/core/provider/database_provider.dart';
import 'package:zlux_pos/features/order/data/datasource/order_local_datasource.dart';
import 'package:zlux_pos/features/order/data/datasource/order_remote_datasource.dart';
import 'package:zlux_pos/features/order/data/repository/order_repository_impl.dart';
import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';
import 'package:zlux_pos/features/order/domain/usecase/create_order_usecase.dart';
import 'package:zlux_pos/features/order/domain/usecase/delete_order_usecase.dart';
import 'package:zlux_pos/features/order/domain/usecase/get_order_by_id_usecase.dart';
import 'package:zlux_pos/features/order/domain/usecase/mark_order_finished_usecase.dart';
import 'package:zlux_pos/features/order/domain/usecase/pull_order_usecase.dart';
import 'package:zlux_pos/features/order/domain/usecase/pull_order_usecase.dart';
import 'package:zlux_pos/features/order/domain/usecase/update_order_usecase.dart';
import 'package:zlux_pos/features/order/domain/usecase/watch_order_by_date_usecase.dart';
import 'package:zlux_pos/features/order/domain/usecase/watch_orderdate_month_usecase.dart';


part 'order_provider.g.dart';

String _requireUid() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw StateError('User is not authenticated');
  return user.uid;
}

@riverpod
OrderLocalDataSource orderLocalDataSource(OrderLocalDataSourceRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return OrderLocalDataSource(db.ordersDao);
}

@riverpod
OrderRemoteDataSource orderRemoteDataSource(OrderRemoteDataSourceRef ref) {
  return OrderRemoteDataSource(FirebaseFirestore.instance);
}

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepositoryImpl(
    local: ref.watch(orderLocalDataSourceProvider),
    remote: ref.watch(orderRemoteDataSourceProvider),
    ownerId: _requireUid,
  );
}

@riverpod
WatchOrdersByDateUsecase watchOrdersByDateUsecase(
  WatchOrdersByDateUsecaseRef ref,
) {
  return WatchOrdersByDateUsecase(ref.watch(orderRepositoryProvider));
}

@riverpod
WatchOrderDateMonthUsecase watchOrderDateMonthUsecase(
  WatchOrderDateMonthUsecaseRef ref,
) {
  return WatchOrderDateMonthUsecase(ref.watch(orderRepositoryProvider));
}

@riverpod
MarkOrderFinishedUsecase markOrderFinishedUsecase(
  MarkOrderFinishedUsecaseRef ref,
) {
  return MarkOrderFinishedUsecase(ref.watch(orderRepositoryProvider));
}

@riverpod
CreateOrderUsecase createOrderUsecase(CreateOrderUsecaseRef ref) {
  return CreateOrderUsecase(ref.watch(orderRepositoryProvider));
}

@riverpod
UpdateOrderUsecase updateOrderUsecase(UpdateOrderUsecaseRef ref) {
  return UpdateOrderUsecase(ref.watch(orderRepositoryProvider));
}

@riverpod
GetOrderByIdUsecase getOrderByIdUsecase(GetOrderByIdUsecaseRef ref) {
  return GetOrderByIdUsecase(ref.watch(orderRepositoryProvider));
}

@riverpod
DeleteOrderUsecase deleteOrderUsecase(DeleteOrderUsecaseRef ref) {
  return DeleteOrderUsecase(ref.watch(orderRepositoryProvider));
}

@riverpod
PullOrdersUsecase pullOrdersUsecase(PullOrdersUsecaseRef ref) {
  return PullOrdersUsecase(ref.watch(orderRepositoryProvider));
}

@riverpod
Stream<List<DateTime>> historyDates(
  HistoryDatesRef ref, {
  required int year,
  required int month,
}) {
  final usecase = ref.watch(watchOrderDateMonthUsecaseProvider);
  return usecase(year: year, month: month);
}
