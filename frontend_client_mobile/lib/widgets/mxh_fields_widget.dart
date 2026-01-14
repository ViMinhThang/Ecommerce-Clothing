import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialWidget extends StatelessWidget {
  final String type; // 'google', 'facebook', 'apple'
  final String text;
  final VoidCallback? onTap;

  const SocialWidget({
    super.key,
    required this.type,
    required this.text,
    this.onTap,
  });

  // Legacy constructor for backward compatibility
  const SocialWidget.legacy({
    super.key,
    IconData? icondata,
    required this.text,
    Color? textColor,
    Color? color,
    this.onTap,
  }) : type = 'custom';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _getBackgroundColor(),
          border: Border.all(
            color: type == 'google' ? Colors.grey.shade300 : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.lora(
                color: _getTextColor(),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (type) {
      case 'google':
        return _buildGoogleIcon();
      case 'facebook':
        return const Icon(Icons.facebook, color: Colors.white, size: 24);
      case 'apple':
        return const Icon(Icons.apple, color: Colors.white, size: 26);
      default:
        return const SizedBox.shrink();
    }
  }

  // Custom Google "G" icon with brand colors
  Widget _buildGoogleIcon() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color(0xFF4285F4), // Google Blue
                  Color(0xFF34A853), // Google Green
                  Color(0xFFFBBC05), // Google Yellow
                  Color(0xFFEA4335), // Google Red
                ],
              ).createShader(const Rect.fromLTWH(0, 0, 20, 20)),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case 'google':
        return Colors.white;
      case 'facebook':
        return const Color(0xFF1877F2); // Facebook Blue
      case 'apple':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case 'google':
        return Colors.black87;
      case 'facebook':
      case 'apple':
        return Colors.white;
      default:
        return Colors.black;
    }
  }
}
