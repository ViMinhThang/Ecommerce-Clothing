import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product.dart';
import '../../config/theme_config.dart';
import '../shared/empty_state_widget.dart';
import 'product_card.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final bool isLoading;
  final bool isMoreLoading;
  final Function(Product) onEdit;
  final Function(Product) onDelete;
  final ScrollController? scrollController;

  const ProductListView({
    super.key,
    required this.products,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
    this.isMoreLoading = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryBlack,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyStateWidget(
          icon: Icons.inventory_2_outlined,
          message: 'No products yet',
          subtitle: 'Create your first product to get started',
        ),
      );
    }

    return SliverList.builder(
      itemCount: products.length + (isMoreLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                color: AppTheme.primaryBlack,
                strokeWidth: 2,
              ),
            ),
          );
        }
        final product = products[index];
        return ProductCard(
          product: product,
          onEdit: () => onEdit(product),
          onDelete: () => onDelete(product),
        );
      },
    );
  }
}
