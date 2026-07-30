import 'dart:async';

import 'package:zlux_pos/features/order/data/datasource/order_local_datasource.dart';
import 'package:zlux_pos/features/order/data/datasource/order_remote_datasource.dart';
import 'package:zlux_pos/features/order/domain/repository/order_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/entities/payment_method.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _local;
  final OrderRemoteDataSource _remote;
  final String Function() _ownerId;

  OrderRepositoryImpl({
    required OrderLocalDataSource local,
    required OrderRemoteDataSource remote,
    required String Function() ownerId,
  })  : _local = local,
        _remote = remote,
        _ownerId = ownerId;

  @override
  Stream<List<OrderEntity>> watchOrdersByDate(DateTime date) =>
      _local.watchOrdersByDate(_ownerId(), date);

  @override
  Stream<List<DateTime>> watchOrderDateMonth({
    required int year,
    required int month,
  }) =>
      _local.watchOrderDateMonth(_ownerId(), year, month);

  @override
  Future<OrderEntity?> getOrderById(String orderId) => _local.getOrder(orderId);

  @override
  Future<Result<String>> createOrder({
    required String notes,
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    required double total,
  }) async {
    try {
      final ownerId = _ownerId();
      final orderId = await _local.createOrder(
        ownerId: ownerId,
        notes: notes,
        items: items,
        paymentMethod: paymentMethod,
        total: total,
      );
      unawaited(_pushOrder(orderId));
      return Success(orderId);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateOrder({
    required String orderId,
    required String notes,
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    required double total,
  }) async {
    try {
      await _local.updateOrder(
        orderId: orderId,
        notes: notes,
        items: items,
        paymentMethod: paymentMethod,
        total: total,
      );
      unawaited(_pushOrder(orderId));
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markOrderFinished(String orderId) async {
    try {
      await _local.markFinished(orderId);
      unawaited(_pushOrder(orderId));
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  Future<void> _pushOrder(String orderId) async {
    try {
      final ownerId = _ownerId();
      final order = await _local.getOrder(orderId);
      if (order == null) return;

      await _remote.pushOrder(
        ownerId,
        OrderModel(
          id: order.id,
          status: order.status,
          notes: order.notes,
          items: order.items,
          total: order.total,
          createdAt: order.createdAt,
          paymentMethod: order.paymentMethod,
        ),
      );
      await _local.markSynced(orderId);
    } catch (_) {

    }
  }

  @override
  Future<void> syncPending() async {
    final ownerId = _ownerId();
    final pending = await _local.getUnsynced(ownerId);
    for (final order in pending) {
      await _pushOrder(order.id);
    }
  }

  @override
  Future<Result<void>> deleteOrder(String orderId) async {
    try {
      await _local.deleteOrder(orderId);
      unawaited(_deleteRemoteOrder(orderId));
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

  Future<void> _deleteRemoteOrder(String orderId) async {
    try {
      await _remote.deleteOrder(orderId);
    } catch (_) {
  
    }
  }

  @override
  Future<Result<void>> pullAll() async {
    try {
      final ownerId = _ownerId();
      final remoteOrders = await _remote.fetchOrders(ownerId);
      await _local.pullAll(ownerId, remoteOrders);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ServerFailure(e.toString()));
    }
  }

}

