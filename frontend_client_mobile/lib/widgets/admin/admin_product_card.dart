import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import '../../models/product.dart';
import '../../utils/image_helper.dart';

class AdminProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<AdminProductCard> createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
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
              _buildProductImage(),
              const SizedBox(width: AppTheme.spaceMD),
              Expanded(child: _buildProductInfo()),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl = ImageHelper.getFullImageUrl(
      widget.product.primaryImageUrl,
    );
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
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
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
        _buildCategoryChip(),
        const SizedBox(height: AppTheme.spaceSM),
        Text(
          widget.product.priceDisplayText,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: AppTheme.spaceXS),
        _buildMetadata(),
      ],
    );
  }

  Widget _buildCategoryChip() {
    return Container(
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
        widget.product.category.name,
        style: AppTheme.caption.copyWith(
          color: AppTheme.mediumGray,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildMetadata() {
    return Row(
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
          '${widget.product.variants.length ?? 0} variants',
          style: AppTheme.caption.copyWith(
            fontSize: 11,
            color: AppTheme.mediumGray,
          ),
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
