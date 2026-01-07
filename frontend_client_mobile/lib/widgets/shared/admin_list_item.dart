import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme_config.dart';

class AdminListItem extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? editTooltip;
  final String? deleteTooltip;

  const AdminListItem({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.editTooltip,
    this.deleteTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: leading,
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle != null
            ? Padding(padding: const EdgeInsets.only(top: 6), child: subtitle)
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
