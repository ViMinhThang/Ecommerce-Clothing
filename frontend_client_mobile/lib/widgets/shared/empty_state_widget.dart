import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.iconSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: AppTheme.lightGray),
          const SizedBox(height: AppTheme.spaceMD),
          Text(
            message,
            style: AppTheme.h3.copyWith(color: AppTheme.mediumGray),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spaceXS),
            Text(
              subtitle!,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.lightGray),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
