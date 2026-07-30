import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'thermal_printer_service.dart';

part 'printing_providers.g.dart';

@Riverpod(keepAlive: true)
ThermalPrinterService thermalPrinterService(ThermalPrinterServiceRef ref) {
  return ThermalPrinterService();
}