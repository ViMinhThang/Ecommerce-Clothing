import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

enum StatusBadgeType { orderStatus, userRole, activeInactive }

/// Generic status badge widget for displaying status/role information
/// Supports different styles for orders, users, and general active/inactive states
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final Color? customColor;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.activeInactive,
    this.customColor,
  });

  Color _getBadgeColor() {
    if (customColor != null) return customColor!;

    switch (type) {
      case StatusBadgeType.orderStatus:
        return _getOrderStatusColor(label.toLowerCase());
      case StatusBadgeType.userRole:
        return AppTheme.mediumGray;
      case StatusBadgeType.activeInactive:
        return label.toLowerCase() == 'active' ? Colors.green : Colors.red;
    }
  }

  Color _getOrderStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return AppTheme.mediumGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getBadgeColor();
    final isUserRole = type == StatusBadgeType.userRole;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isUserRole
            ? AppTheme.veryLightGray
            : badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: isUserRole
            ? null
            : Border.all(color: badgeColor.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTheme.bodySmall.copyWith(
          color: isUserRole ? AppTheme.primaryBlack : badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
