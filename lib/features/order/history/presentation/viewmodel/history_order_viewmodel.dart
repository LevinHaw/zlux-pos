import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/order/presentation/order_provider.dart';

import '../../../../../core/printing/printing_providers.dart';
import '../../../../setup/presentation/provider/setup_provider.dart';
import '../../../domain/entities/order_entity.dart';

part 'history_order_viewmodel.g.dart';


@riverpod
class HistoryOrderViewModel extends _$HistoryOrderViewModel {
  @override
  Stream<List<OrderEntity>> build(DateTime date) {
    return ref.watch(watchOrdersByDateUsecaseProvider)(date);
  }

  Future<void> finishOrder(String orderId) async {
    final usecase = ref.read(markOrderFinishedUsecaseProvider);
    await usecase(orderId);

  }

  Future<void> deleteOrder(String orderId) async {
    final usecase = ref.read(deleteOrderUsecaseProvider);
    await usecase(orderId);
  }

  Future<bool> printOrder(OrderEntity order) async {
    final printer = ref.read(thermalPrinterServiceProvider);

    var connected = await printer.isConnected;
    if (!connected) {
      final lastMac = await printer.getLastPrinterMac();
      if (lastMac == null) return false;
      connected = await printer.connect(lastMac);
      if (!connected) return false;
    }

    final merchantResult = await ref.read(getMerchantUsecaseProvider)();
    final merchant = merchantResult.dataOrNull;

    return printer.printOrderReceipt(order, merchant: merchant);
  }
}