import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

class RemovableCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onRemove;
  final String removeTooltip;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const RemovableCard({
    super.key,
    required this.child,
    required this.onRemove,
    this.removeTooltip = 'Remove',
    this.padding = const EdgeInsets.fromLTRB(12, 24, 12, 12),
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.mediumGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(padding: padding, child: child),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18, color: Color(0xFFEF5350)),
              splashRadius: 16,
              tooltip: removeTooltip,
              onPressed: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
