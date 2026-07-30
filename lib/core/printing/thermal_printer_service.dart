import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zlux_pos/features/order/domain/entities/payment_method.dart';

import '../../features/order/domain/entities/order_entity.dart';
import '../../features/setup/domain/entities/merchant_entity.dart';

enum BluetoothPermissionResult {
  granted,
  denied,
  permanentlyDenied,
}

class ThermalPrinterService {
  static const _lastPrinterMacKey = 'thermal_printer_last_mac';

  Future<BluetoothPermissionResult> requestPermissions() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return BluetoothPermissionResult.granted;
    }
    final permissions = Platform.isAndroid
        ? [Permission.bluetoothConnect, Permission.bluetoothScan]
        : [Permission.bluetooth];

    final statuses = await permissions.request();

    final anyPermanentlyDenied = statuses.values.any(
      (status) => status.isPermanentlyDenied,
    );
    final allGranted = statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );

    if (allGranted) return BluetoothPermissionResult.granted;
    if (anyPermanentlyDenied) return BluetoothPermissionResult.permanentlyDenied;
    return BluetoothPermissionResult.denied;
  }

  Future<bool> openSettings() => openAppSettings();

  Future<List<BluetoothInfo>> getPairedDevices() {
    return PrintBluetoothThermal.pairedBluetooths;
  }

  Future<bool> get isConnected => PrintBluetoothThermal.connectionStatus;

  Future<bool> connect(String macAddress) async {
    final result =
        await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
    if (result) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastPrinterMacKey, macAddress);
    }
    return result;
  }

  Future<String?> getLastPrinterMac() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastPrinterMacKey);
  }

  Future<void> disconnect() => PrintBluetoothThermal.disconnect;

  static final _dateFormat = DateFormat('d MMMM y');
  static final _timeFormat = DateFormat('HH:mm');
  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  Future<bool> printOrderReceipt(
    OrderEntity order, {
    MerchantEntity? merchant,
  }) async {
    final connected = await PrintBluetoothThermal.connectionStatus;
    if (!connected) return false;

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();

    final merchantName =
        (merchant?.name.isNotEmpty ?? false) ? merchant!.name : 'Name merchant';
    final merchantAddress = merchant?.address ?? '';

    bytes += generator.text(
      merchantName,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    if (merchantAddress.isNotEmpty) {
      bytes += generator.text(
        merchantAddress,
        styles: const PosStyles(align: PosAlign.center),
      );
    }
    bytes += generator.hr();

    bytes += generator.text(
      'Receipt',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: _dateFormat.format(order.createdAt).toLowerCase(), width: 7),
      PosColumn(
        text: _timeFormat.format(order.createdAt),
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    final shortId = order.id.length >= 7 ? order.id.substring(0, 7) : order.id;
    bytes += generator.row([
      PosColumn(text: 'Order', width: 5),
      PosColumn(
        text: shortId,
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.hr();

    // Item table header.
    bytes += generator.row([
      PosColumn(text: 'Item', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(
        text: 'Qty',
        width: 2,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      PosColumn(
        text: 'Price',
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.hr();

    for (final item in order.items) {
      bytes += generator.row([
        PosColumn(text: item.name, width: 6),
        PosColumn(
          text: '${item.quantity}',
          width: 2,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: item.subtotal.toStringAsFixed(0),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: _currencyFormat.format(order.total),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.feed(2);
    bytes += generator.cut();

    return PrintBluetoothThermal.writeBytes(bytes);
  }
}