import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:zlux_pos/core/database/dao/orders_dao.dart';

import '../../../../core/database/app_database.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/entities/payment_method.dart';

extension OrderWithItemsRowX on OrderWithItemsRow {
  OrderEntity toEntity() => OrderEntity(
        id: order.id,
        status:
            order.status == 'finish' ? OrderStatus.finish : OrderStatus.pending,
        notes: order.notes,
        total: order.total,
        createdAt: order.createdAt,
        isSynced: order.isSynced,
        paymentMethod: order.paymentMethod == 'transfer'
            ? PaymentMethod.transfer
            : PaymentMethod.cash,
        items: items
            .map(
              (i) => OrderItemEntity(
                id: i.id,
                productId: i.productId,
                name: i.name,
                quantity: i.quantity,
                price: i.price,
              ),
            )
            .toList(),
      );
}

class OrderLocalDataSource {
  final OrdersDao _dao;
  final _uuid = const Uuid();

  OrderLocalDataSource(this._dao);

  Stream<List<OrderEntity>> watchOrdersByDate(String ownerId, DateTime date) {
    return _dao
        .watchOrdersByDate(ownerId, date)
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Stream<List<DateTime>> watchOrderDateMonth(
    String ownerId,
    int year,
    int month,
  ) {
    return _dao.watchOrderDateMonth(ownerId, year, month);
  }

  Future<OrderEntity?> getOrder(String orderId) async {
    final row = await _dao.getOrderById(orderId);
    return row?.toEntity();
  }

  Future<void> markFinished(String orderId) => _dao.markFinished(orderId);

  Future<void> markSynced(String orderId) => _dao.markSynced(orderId);

  Future<List<OrderEntity>> getUnsynced(String ownerId) async {
    final rows = await _dao.getUnsyncedOrders(ownerId);
    return rows.map((r) => r.toEntity()).toList();
  }

  Future<void> deleteOrder(String orderId) => _dao.deleteOrder(orderId);

  /// Writes orders fetched from Firestore into the local db, replacing
  /// each order's items with the remote copy and marking it as synced.
  Future<void> pullAll(String ownerId, List<OrderModel> remoteOrders) async {
    for (final order in remoteOrders) {
      await _dao.upsertOrderFromRemote(
        OrdersCompanion(
          id: Value(order.id),
          ownerId: Value(ownerId),
          status: Value(order.status.name),
          notes: Value(order.notes),
          total: Value(order.total),
          createdAt: Value(order.createdAt),
          isSynced: const Value(true),
          paymentMethod: Value(order.paymentMethod.name),
        ),
        order.items
            .map(
              (i) => OrderItemsCompanion(
                id: Value(_uuid.v4()),
                orderId: Value(order.id),
                productId: Value(i.productId),
                name: Value(i.name),
                quantity: Value(i.quantity),
                price: Value(i.price),
              ),
            )
            .toList(),
      );
    }
  }

  Future<String> createOrder({
    required String ownerId,
    required String notes,
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    required double total,
  }) async {
    final orderId = _uuid.v4();
    final now = DateTime.now();

    await _dao.insertOrder(
      OrdersCompanion(
        id: Value(orderId),
        ownerId: Value(ownerId),
        status: const Value('pending'),
        notes: Value(notes),
        total: Value(total),
        createdAt: Value(now),
        isSynced: const Value(false),
        paymentMethod: Value(paymentMethod.name),
      ),
      _toItemCompanions(orderId, items),
    );

    return orderId;
  }

  Future<void> updateOrder({
    required String orderId,
    required String notes,
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    required double total,
  }) {
    return _dao.updateOrderItems(
      orderId,
      OrdersCompanion(
        notes: Value(notes),
        total: Value(total),
        paymentMethod: Value(paymentMethod.name),
        isSynced: const Value(false),
      ),
      _toItemCompanions(orderId, items),
    );
  }

  List<OrderItemsCompanion> _toItemCompanions(
    String orderId,
    List<OrderItemEntity> items,
  ) {
    return items
        .map(
          (i) => OrderItemsCompanion(
            id: Value(_uuid.v4()),
            orderId: Value(orderId),
            productId: Value(i.productId),
            name: Value(i.name),
            quantity: Value(i.quantity),
            price: Value(i.price),
          ),
        )
        .toList();
  }
}
