import 'package:flutter/material.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';

import 'product_form_view.dart';

class NewProductScreen extends StatelessWidget {
  const NewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductFormView(
      productId: null,
      title: context.strings.newProduct,
    );
  }
}
