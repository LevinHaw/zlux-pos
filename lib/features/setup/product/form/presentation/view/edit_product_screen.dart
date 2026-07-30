import 'package:flutter/material.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';

import 'product_form_view.dart';

class EditProductScreen extends StatelessWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ProductFormView(
      productId: productId,
      title: context.strings.editProduct,
    );
  }
}
