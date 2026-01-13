import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

class VariantsEmptyState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const VariantsEmptyState({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppTheme.borderRadiusSM,
              border: Border.all(color: Colors.black12, width: 0.5),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 28,
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No variants yet',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add product variants with colors, sizes, and prices',
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: Colors.black38,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: onAddPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.borderRadiusXS,
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: Text(
              'Add First Variant',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
