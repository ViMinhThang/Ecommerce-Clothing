import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

/// Minimalist animated chip/tag component
/// Perfect for filters, categories, and selections
class AnimatedChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Widget? avatar;
  final EdgeInsetsGeometry? padding;

  const AnimatedChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
    this.avatar,
    this.padding,
  });

  @override
  State<AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<AnimatedChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    return widget.isSelected ? AppTheme.primaryBlack : AppTheme.primaryWhite;
  }

  Color get _textColor {
    return widget.isSelected ? AppTheme.primaryWhite : AppTheme.primaryBlack;
  }

  Border get _border {
    return widget.isSelected
        ? Border.all(color: AppTheme.primaryBlack, width: 1)
        : AppTheme.borderThin;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppTheme.durationNormal,
          curve: AppTheme.curveDefault,
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceMD,
                vertical: AppTheme.spaceSM,
              ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            border: _border,
            borderRadius: BorderRadius.circular(100), // Pill shape
            boxShadow: widget.isSelected ? AppTheme.shadowSM : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.avatar != null) ...[
                widget.avatar!,
                const SizedBox(width: AppTheme.spaceXS),
              ],
              Text(
                widget.label,
                style: AppTheme.bodyMedium.copyWith(
                  color: _textColor,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
              if (widget.onDelete != null) ...[
                const SizedBox(width: AppTheme.spaceXS),
                _buildDeleteButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        _controller.reverse().then((_) {
          widget.onDelete?.call();
        });
      },
      child: Icon(Icons.close, size: 16, color: _textColor),
    );
  }
}
