import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import '../../models/product.dart';
import '../shared/empty_state_widget.dart';
import '../shared/list_footer_indicator.dart';
import 'admin_product_card.dart';

/// A sliver list view for displaying products with lazy loading support
class ProductListView extends StatelessWidget {
  final List<Product> products;
  final bool isLoading;
  final bool isMoreLoading;
  final bool hasMore;
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
    this.hasMore = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return _buildLoadingState();
    }

    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return _buildProductList();
  }

  Widget _buildLoadingState() {
    return const SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryBlack,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SliverFillRemaining(
      child: EmptyStateWidget(
        message: 'No products yet\nCreate your first product to get started',
        icon: Icons.inventory_2_outlined,
      ),
    );
  }

  Widget _buildProductList() {
    final hasFooter = isMoreLoading || (!hasMore && products.isNotEmpty);

    return SliverList.builder(
      itemCount: products.length + (hasFooter ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return ListFooterIndicator(isLoading: isMoreLoading);
        }

        final product = products[index];
        return AdminProductCard(
          product: product,
          onEdit: () => onEdit(product),
          onDelete: () => onDelete(product),
        );
      },
    );
  }
}
