import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

enum ElegantButtonStyle {
  primary, // Black bg, white text
  secondary, // White bg, black text with border
  text, // No bg, black text
}

/// Elegant button with minimalist design and smooth animations
class ElegantButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ElegantButtonStyle style;
  final Widget? icon;
  final bool isLoading;
  final bool showSuccessCheck;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const ElegantButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = ElegantButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.showSuccessCheck = false,
    this.width,
    this.padding,
  });

  @override
  State<ElegantButton> createState() => _ElegantButtonState();
}

class _ElegantButtonState extends State<ElegantButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.durationInstant,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.curveDefault),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  Color get _backgroundColor {
    if (widget.onPressed == null) {
      return AppTheme.disabledBackground;
    }
    switch (widget.style) {
      case ElegantButtonStyle.primary:
        return AppTheme.primaryBlack;
      case ElegantButtonStyle.secondary:
      case ElegantButtonStyle.text:
        return AppTheme.primaryWhite;
    }
  }

  Color get _textColor {
    if (widget.onPressed == null) {
      return AppTheme.disabledText;
    }
    switch (widget.style) {
      case ElegantButtonStyle.primary:
        return AppTheme.primaryWhite;
      case ElegantButtonStyle.secondary:
      case ElegantButtonStyle.text:
        return AppTheme.primaryBlack;
    }
  }

  Border? get _border {
    if (widget.style == ElegantButtonStyle.text) {
      return null;
    }
    if (widget.style == ElegantButtonStyle.secondary) {
      return AppTheme.borderBlack;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: GestureDetector(
        onTapDown: widget.onPressed != null ? _onTapDown : null,
        onTapUp: widget.onPressed != null ? _onTapUp : null,
        onTapCancel: widget.onPressed != null ? _onTapCancel : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: AppTheme.durationNormal,
          curve: AppTheme.curveDefault,
          width: widget.width,
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceLG,
                vertical: AppTheme.spaceMD,
              ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            border: _border,
            borderRadius: AppTheme.borderRadiusSM,
            boxShadow: widget.style == ElegantButtonStyle.text
                ? null
                : (_isPressed ? [] : AppTheme.shadowSM),
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_textColor),
          ),
        ),
      );
    }

    if (widget.showSuccessCheck) {
      return Center(child: Icon(Icons.check, color: _textColor, size: 20));
    }

    Widget textWidget = Text(
      widget.text,
      style: AppTheme.button.copyWith(color: _textColor),
      textAlign: TextAlign.center,
    );

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon!,
          const SizedBox(width: AppTheme.spaceSM),
          textWidget,
        ],
      );
    }

    return Center(child: textWidget);
  }
}
