import 'package:flutter/material.dart';
import 'dart:ui';
import '../../config/theme_config.dart';

/// Elegant glass card with frosted glass effect
/// Used throughout the app for a sophisticated minimalist look
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Border? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool enableHoverEffect;
  final double blurStrength;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.border,
    this.borderRadius,
    this.shadows,
    this.onTap,
    this.enableHoverEffect = false,
    this.blurStrength = AppTheme.glassBlurStrength,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.curveDefault),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    if (!widget.enableHoverEffect) return;
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? AppTheme.borderRadiusMD,
              boxShadow: _isHovered
                  ? AppTheme.shadowMD
                  : (widget.shadows ?? AppTheme.shadowSM),
            ),
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? AppTheme.borderRadiusMD,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blurStrength,
                  sigmaY: widget.blurStrength,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color ?? AppTheme.glassTint,
                    border:
                        widget.border ??
                        Border.all(
                          color: _isHovered
                              ? AppTheme.lightGray
                              : AppTheme.glassBorder,
                          width: 1,
                        ),
                    borderRadius:
                        widget.borderRadius ?? AppTheme.borderRadiusMD,
                  ),
                  padding:
                      widget.padding ?? const EdgeInsets.all(AppTheme.spaceMD),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
