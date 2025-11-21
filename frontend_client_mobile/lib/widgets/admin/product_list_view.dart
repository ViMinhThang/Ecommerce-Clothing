import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/product.dart';
import '../../config/theme_config.dart';

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
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryBlack,
          strokeWidth: 2,
        ),
      );
    }

    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
        return _ProductCard(
          product: product,
          onEdit: () => onEdit(product),
          onDelete: () => onDelete(product),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.lightGray),
          const SizedBox(height: AppTheme.spaceMD),
          Text(
            'No products yet',
            style: AppTheme.h3.copyWith(color: AppTheme.mediumGray),
          ),
          const SizedBox(height: AppTheme.spaceXS),
          Text(
            'Create your first product to get started',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.lightGray),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppTheme.durationNormal,
        curve: AppTheme.curveDefault,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryWhite,
          border: Border.all(
            color: _isHovered ? AppTheme.mediumGray : AppTheme.veryLightGray,
            width: 1,
          ),
          borderRadius: AppTheme.borderRadiusMD,
          boxShadow: _isHovered ? AppTheme.shadowMD : AppTheme.shadowSM,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              _buildProductImage(),
              const SizedBox(width: AppTheme.spaceMD),
              // Product Info
              Expanded(child: _buildProductInfo()),
              // Actions
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.offWhite,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: AppTheme.veryLightGray, width: 1),
      ),
      child: ClipRRect(
        borderRadius: AppTheme.borderRadiusSM,
        child:
            widget.product.imageUrl != null &&
                widget.product.imageUrl!.isNotEmpty
            ? Image.network(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return const Center(
      child: Icon(Icons.image_outlined, color: AppTheme.lightGray, size: 32),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          widget.product.name,
          style: AppTheme.h4.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppTheme.spaceXS),
        // Category
        if (widget.product.category != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceSM,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppTheme.offWhite,
              border: Border.all(color: AppTheme.veryLightGray, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.product.category!.name,
              style: AppTheme.caption.copyWith(
                color: AppTheme.mediumGray,
                fontSize: 11,
              ),
            ),
          ),
        const SizedBox(height: AppTheme.spaceSM),
        // Price
        Text(
          widget.product.priceDisplayText,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: AppTheme.spaceXS),
        // Metadata
        Row(
          children: [
            Icon(Icons.circle, size: 8, color: AppTheme.primaryBlack),
            const SizedBox(width: 4),
            Text(
              'In Stock',
              style: AppTheme.caption.copyWith(
                fontSize: 11,
                color: AppTheme.mediumGray,
              ),
            ),
            const SizedBox(width: AppTheme.spaceSM),
            Text('•', style: TextStyle(color: AppTheme.lightGray)),
            const SizedBox(width: AppTheme.spaceSM),
            Text(
              '${widget.product.variants?.length ?? 0} variants',
              style: AppTheme.caption.copyWith(
                fontSize: 11,
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.edit_outlined,
          onTap: widget.onEdit,
          tooltip: 'Edit',
        ),
        const SizedBox(height: AppTheme.spaceXS),
        _buildActionButton(
          icon: Icons.delete_outline,
          onTap: widget.onDelete,
          tooltip: 'Delete',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.hoverOverlay : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primaryBlack),
        ),
      ),
    );
  }
}
