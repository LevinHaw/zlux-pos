import 'package:flutter/material.dart';

import '../../../../transaction/presentation/view/transaction_screen.dart';

class OrderEditScreen extends StatelessWidget {
  final String orderId;

  const OrderEditScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return TransactionScreen(orderId: orderId);
  }
}
