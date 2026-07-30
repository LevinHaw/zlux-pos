import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:zlux_pos/features/order/history/presentation/viewmodel/history_order_viewmodel.dart';

import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import '../../../../../core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import '../../../../../core/printing/printing_providers.dart';
import '../../../../../core/printing/thermal_printer_service.dart';
import '../../../../../core/router/route_paths.dart';
import '../../../../setup/presentation/provider/setup_provider.dart';
import '../../../domain/entities/order_entity.dart';

class HistoryOrderScreen extends ConsumerStatefulWidget {
  final DateTime date;

  const HistoryOrderScreen({super.key, required this.date});

  @override
  ConsumerState<HistoryOrderScreen> createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends ConsumerState<HistoryOrderScreen> {
  final _busyOrderIds = <String>{};

  Future<void> _onFinish(OrderEntity order) async {
    setState(() => _busyOrderIds.add(order.id));
    await ref
        .read(historyOrderViewModelProvider(widget.date).notifier)
        .finishOrder(order.id);
    if (mounted) setState(() => _busyOrderIds.remove(order.id));
  }

  void _showPermissionSnackBar(
    BluetoothPermissionResult result,
    OrderEntity order,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    if (result == BluetoothPermissionResult.permanentlyDenied) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(context.strings.bluetoothPermissionPermanentlyDenied),
          action: SnackBarAction(
            label: context.strings.openSettings,
            onPressed: () {
              ref.read(thermalPrinterServiceProvider).openSettings();
            },
          ),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(context.strings.bluetoothPermissionDenied),
        action: SnackBarAction(
          label: context.strings.retry,
          onPressed: () => _onPrint(order),
        ),
      ),
    );
  }

  Future<void> _onDelete(OrderEntity order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(dialogContext.strings.deleteOrder),
            content: Text(dialogContext.strings.deleteOrderMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(dialogContext.strings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(dialogContext.strings.delete),
              ),
            ],
          ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _busyOrderIds.add(order.id));
    await ref
        .read(historyOrderViewModelProvider(widget.date).notifier)
        .deleteOrder(order.id);
    if (mounted) setState(() => _busyOrderIds.remove(order.id));
  }

  Future<void> _onPrint(OrderEntity order) async {
    setState(() => _busyOrderIds.add(order.id));

    final printerService = ref.read(thermalPrinterServiceProvider);
    final permissionResult = await printerService.requestPermissions();

    if (!mounted) return;
    if (permissionResult != BluetoothPermissionResult.granted) {
      setState(() => _busyOrderIds.remove(order.id));
      _showPermissionSnackBar(permissionResult, order);
      return;
    }

    final viewModel = ref.read(
      historyOrderViewModelProvider(widget.date).notifier,
    );
    final printed = await viewModel.printOrder(order);

    if (printed) {
      if (mounted) setState(() => _busyOrderIds.remove(order.id));
      return;
    }

    // Not connected to any printer yet — let the user pick a paired device.
    final devices = await printerService.getPairedDevices();

    if (!mounted) return;

    if (devices.isEmpty) {
      setState(() => _busyOrderIds.remove(order.id));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.strings.noPairedPrinter)));
      return;
    }

    final selected = await showModalBottomSheet<BluetoothInfo>(
      context: context,
      builder:
          (sheetContext) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              children:
                  devices
                      .map(
                        (d) => ListTile(
                          leading: const Icon(Icons.print),
                          title: Text(d.name),
                          subtitle: Text(d.macAdress),
                          onTap: () => Navigator.pop(sheetContext, d),
                        ),
                      )
                      .toList(),
            ),
          ),
    );

    if (!mounted) return;
    if (selected == null) {
      setState(() => _busyOrderIds.remove(order.id));
      return;
    }

    final connected = await printerService.connect(selected.macAdress);
    if (!mounted) return;

    if (!connected) {
      setState(() => _busyOrderIds.remove(order.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.printerConnectFailed)),
      );
      return;
    }

    final merchantResult = await ref.read(getMerchantUsecaseProvider)();
    final result = await printerService.printOrderReceipt(
      order,
      merchant: merchantResult.dataOrNull,
    );
    if (!mounted) return;
    setState(() => _busyOrderIds.remove(order.id));
    if (!result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.strings.printFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(historyOrderViewModelProvider(widget.date));

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(context.strings.historyOrder),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.strings.exportComingSoon)),
              );
            },
            child: Text(context.strings.export),
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(child: Text(context.strings.noOrdersThisDay));
          }
          return ListView.separated(
            padding: EdgeInsets.all(AppSizes.lg),
            itemCount: orders.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSizes.md),
            itemBuilder: (context, index) {
              final order = orders[index];
              final isBusy = _busyOrderIds.contains(order.id);
              return _OrderCard(
                order: order,
                isBusy: isBusy,
                onEdit:
                    () => context.push('${RoutePaths.editOrder}/${order.id}'),
                onFinish: () => _onFinish(order),
                onPrint: () => _onPrint(order),
                onDelete: () => _onDelete(order),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  final bool isBusy;
  final VoidCallback onEdit;
  final VoidCallback onFinish;
  final VoidCallback onPrint;
  final VoidCallback onDelete;

  const _OrderCard({
    required this.order,
    required this.isBusy,
    required this.onEdit,
    required this.onFinish,
    required this.onPrint,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    final isPending = order.status == OrderStatus.pending;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${context.strings.id}: ${order.id.substring(0, 6)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Row(
                    children: [
                      if (!order.isSynced) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: AppSizes.sm),
                      ],
                      Text(
                        isPending
                            ? context.strings.pending
                            : context.strings.finish,
                        style: TextStyle(
                          color: isPending ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 28),
                    ],
                  ),
                ],
              ),
              if (order.notes.isNotEmpty) ...[
                SizedBox(height: AppSizes.md),
                Text('${context.strings.notes}: ${order.notes}'),
              ],
              const Divider(),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('${item.quantity}   ${item.name}')),
                      Text(currency.format(item.subtotal)),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.strings.total,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    currency.format(order.total),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              SizedBox(height: AppSizes.md),
              if (isPending)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isBusy ? null : onEdit,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                        ),
                        child: Text(context.strings.edit),
                      ),
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isBusy ? null : onFinish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.appColors.primary,
                        ),
                        child:
                            isBusy
                                ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(context.strings.finish),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isBusy ? null : onPrint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColors.primary,
                    ),
                    child:
                        isBusy
                            ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(context.strings.print),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: Material(
            color: Colors.red,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: isBusy ? null : onDelete,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.delete, color: Colors.white, size: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}