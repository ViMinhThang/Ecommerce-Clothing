import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

/// Generic list item widget for admin management screens
/// Provides consistent styling and layout for list items across all admin modules
class AdminListItem extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget? subtitle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? editTooltip;
  final String? deleteTooltip;

  const AdminListItem({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onEdit,
    this.onDelete,
    this.editTooltip,
    this.deleteTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusMD,
        border: AppTheme.borderThin,
        boxShadow: AppTheme.shadowSM,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: leading,
        title: Text(title, style: AppTheme.h4.copyWith(fontSize: 16)),
        subtitle: subtitle != null
            ? Padding(padding: const EdgeInsets.only(top: 4), child: subtitle)
            : null,
        trailing: _buildActions(),
      ),
    );
  }

  Widget? _buildActions() {
    if (onEdit == null && onDelete == null) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppTheme.primaryBlack),
            tooltip: editTooltip ?? 'Edit',
            splashRadius: 20,
            onPressed: onEdit,
          ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF5350)),
            tooltip: deleteTooltip ?? 'Delete',
            splashRadius: 20,
            onPressed: onDelete,
          ),
      ],
    );
  }
}
