import 'package:drift/drift.dart';
import 'package:zlux_pos/core/database/table/orders_item_table.dart';
import 'package:zlux_pos/core/database/table/orders_table.dart';

import '../app_database.dart';

part 'orders_dao.g.dart';

class OrderWithItemsRow {
  final Order order;
  final List<OrderItem> items;

  const OrderWithItemsRow({required this.order, required this.items});
}

@DriftAccessor(tables: [Orders, OrderItems])
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  OrdersDao(super.db);

  Stream<List<OrderWithItemsRow>> watchOrdersByDate(
    String ownerId,
    DateTime day,
  ) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final query = select(orders)
      ..where(
        (o) =>
            o.ownerId.equals(ownerId) &
            o.createdAt.isBiggerOrEqualValue(start) &
            o.createdAt.isSmallerThanValue(end),
      )
      ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]);

    return query.watch().asyncMap((orderRows) async {
      final result = <OrderWithItemsRow>[];
      for (final order in orderRows) {
        final items = await (select(orderItems)
              ..where((i) => i.orderId.equals(order.id)))
            .get();
        result.add(OrderWithItemsRow(order: order, items: items));
      }
      return result;
    });
  }

  Stream<List<DateTime>> watchOrderDateMonth(
    String ownerId,
    int year,
    int month,
  ) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final query = selectOnly(orders, distinct: true)
      ..addColumns([orders.createdAt])
      ..where(
        orders.ownerId.equals(ownerId) &
            orders.createdAt.isBiggerOrEqualValue(start) &
            orders.createdAt.isSmallerThanValue(end),
      );

    return query.watch().map((rows) {
      final days = rows
          .map((r) => r.read(orders.createdAt)!)
          .map((dt) => DateTime(dt.year, dt.month, dt.day))
          .toSet()
          .toList();
      days.sort((a, b) => a.compareTo(b));
      return days;
    });
  }

  Future<OrderWithItemsRow?> getOrderById(String orderId) async {
    final order =
        await (select(orders)..where((o) => o.id.equals(orderId)))
            .getSingleOrNull();
    if (order == null) return null;
    final items = await (select(orderItems)
          ..where((i) => i.orderId.equals(orderId)))
        .get();
    return OrderWithItemsRow(order: order, items: items);
  }

  Future<void> insertOrder(
    OrdersCompanion order,
    List<OrderItemsCompanion> items,
  ) {
    return transaction(() async {
      await into(orders).insertOnConflictUpdate(order);
      for (final item in items) {
        await into(orderItems).insertOnConflictUpdate(item);
      }
    });
  }

  Future<void> upsertOrderFromRemote(
    OrdersCompanion order,
    List<OrderItemsCompanion> items,
  ) {
    return transaction(() async {
      await into(orders).insertOnConflictUpdate(order);
      await (delete(orderItems)
            ..where((i) => i.orderId.equals(order.id.value)))
          .go();
      for (final item in items) {
        await into(orderItems).insertOnConflictUpdate(item);
      }
    });
  }

  Future<void> updateOrderItems(
    String orderId,
    OrdersCompanion orderUpdate,
    List<OrderItemsCompanion> items,
  ) {
    return transaction(() async {
      await (update(orders)..where((o) => o.id.equals(orderId)))
          .write(orderUpdate);
      await (delete(orderItems)..where((i) => i.orderId.equals(orderId)))
          .go();
      for (final item in items) {
        await into(orderItems).insertOnConflictUpdate(item);
      }
    });
  }

  Future<void> markFinished(String orderId) {
    return (update(orders)..where((o) => o.id.equals(orderId))).write(
      const OrdersCompanion(
        status: Value('finish'),
        isSynced: Value(false),
      ),
    );
  }

  Future<List<OrderWithItemsRow>> getUnsyncedOrders(String ownerId) async {
    final orderRows = await (select(orders)
          ..where((o) => o.ownerId.equals(ownerId) & o.isSynced.equals(false)))
        .get();
    final result = <OrderWithItemsRow>[];
    for (final order in orderRows) {
      final items = await (select(orderItems)
            ..where((i) => i.orderId.equals(order.id)))
          .get();
      result.add(OrderWithItemsRow(order: order, items: items));
    }
    return result;
  }

  Future<void> markSynced(String orderId) {
    return (update(orders)..where((o) => o.id.equals(orderId)))
        .write(const OrdersCompanion(isSynced: Value(true)));
  }

  Future<void> deleteOrder(String orderId) {
    return transaction(() async {
      await (delete(orderItems)..where((i) => i.orderId.equals(orderId))).go();
      await (delete(orders)..where((o) => o.id.equals(orderId))).go();
    });
  }

}
