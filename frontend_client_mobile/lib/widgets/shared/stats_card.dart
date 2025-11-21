import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

/// Minimal stats card for displaying metrics
class StatsCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppTheme.durationNormal,
          curve: AppTheme.curveDefault,
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          decoration: BoxDecoration(
            color: AppTheme.primaryWhite,
            border: AppTheme.borderThin,
            borderRadius: AppTheme.borderRadiusMD,
            boxShadow: _isHovered ? AppTheme.shadowMD : AppTheme.shadowSM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(widget.icon, size: 20, color: AppTheme.primaryBlack),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: AppTheme.spaceSM),
              Text(
                widget.value,
                style: AppTheme.h2.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppTheme.spaceXS),
              Text(
                widget.label,
                style: AppTheme.caption.copyWith(color: AppTheme.mediumGray),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
