enum PaymentMethod { transfer, cash }

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.transfer:
        return 'Transfer';
      case PaymentMethod.cash:
        return 'Cash';
    }
  }
}
