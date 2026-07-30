import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/entities/payment_method.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.status,
    required super.notes,
    required super.items,
    required super.total,
    required super.createdAt,
    required super.paymentMethod,
  });

  factory OrderModel.fromFirestore(String id, Map<String, dynamic> map) {
    const uuid = Uuid();

    final rawItems = map['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((raw) {
          final itemMap = Map<String, dynamic>.from(raw as Map);
          return OrderItemEntity(
            id: uuid.v4(),
            productId: itemMap['productId'] as String? ?? '',
            name: itemMap['name'] as String? ?? '',
            quantity: (itemMap['quantity'] as num?)?.toInt() ?? 0,
            price: (itemMap['price'] as num?)?.toDouble() ?? 0,
          );
        })
        .toList();

    return OrderModel(
      id: id,
      status: map['status'] == 'finish' ? OrderStatus.finish : OrderStatus.pending,
      notes: map['notes'] as String? ?? '',
      items: items,
      total: (map['total'] as num?)?.toDouble() ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentMethod: map['paymentMethod'] == 'transfer'
          ? PaymentMethod.transfer
          : PaymentMethod.cash,
    );
  }

  Map<String, dynamic> toFirestoreMap(String ownerId) {
    return {
      'ownerId': ownerId,
      'status': status.name,
      'notes': notes,
      'total': total,
      'createdAt': Timestamp.fromDate(createdAt),
      'paymentMethod': paymentMethod.name,
      'items': items
          .map(
            (i) => {
              'productId': i.productId,
              'name': i.name,
              'quantity': i.quantity,
              'price': i.price,
            },
          )
          .toList(),
    };
  }
}
