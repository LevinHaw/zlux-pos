import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import 'package:zlux_pos/core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/router/route_paths.dart';
import 'package:zlux_pos/features/setup/product/list/presentation/viewmodel/product_list_viewmodel.dart';
import 'package:zlux_pos/features/setup/product/presentation/provider/product_provider.dart';

import '../../../domain/entities/product_entity.dart';

class SetupProductScreen extends ConsumerStatefulWidget {
  const SetupProductScreen({super.key});

  @override
  ConsumerState<SetupProductScreen> createState() => _SetupProductScreenState();
}

class _SetupProductScreenState extends ConsumerState<SetupProductScreen> {
  final _busyProductIds = <String>{};

  Future<void> _onDelete(ProductEntity product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(dialogContext.strings.deleteProduct),
            content: Text(dialogContext.strings.deleteProductMessage),
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

    setState(() => _busyProductIds.add(product.id));
    final result = await ref.read(deleteProductUsecaseProvider)(product.id);
    if (!mounted) return;
    setState(() => _busyProductIds.remove(product.id));

    result.when(
      success: (_) {},
      failure: (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListViewModelProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(context.strings.itemsSale),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.strings.productList,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: context.appColors.primary,
                  ),
                  onPressed: () => context.push(RoutePaths.newProduct),
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: AppSizes.md),
            Expanded(
              child: productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return Center(child: Text(context.strings.productList));
                  }
                  return ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) => SizedBox(height: AppSizes.md),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _ProductCard(
                        product: product,
                        isBusy: _busyProductIds.contains(product.id),
                        onDelete: () => _onDelete(product),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('$error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntity product;
  final bool isBusy;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.isBusy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );

    return Container(
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
              Expanded(
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isBusy)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                ),
              ElevatedButton(
                onPressed:
                    isBusy
                        ? null
                        : () => context.push(
                          '${RoutePaths.editProduct}/${product.id}',
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.primary,
                  minimumSize: const Size(0, 32),
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                ),
                child: Text(context.strings.edit),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.category,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(product.category),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.strings.price,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(currency.format(product.price)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
