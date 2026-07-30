import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({String locale = 'id_ID'})
    : _formatter = NumberFormat.decimalPattern(locale);

  final NumberFormat _formatter;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final number = int.parse(digitsOnly);
    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static String formatValue(num value, {String locale = 'id_ID'}) {
    if (value == 0) return '';
    return NumberFormat.decimalPattern(locale).format(value.round());
  }

  static double parse(String formatted) {
    final digitsOnly = formatted.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return 0;
    return double.parse(digitsOnly);
  }
}
