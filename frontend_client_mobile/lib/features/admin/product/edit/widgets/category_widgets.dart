import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

class CategoryLabel extends StatelessWidget {
  const CategoryLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
            borderRadius: AppTheme.borderRadiusXS,
          ),
          child: const Icon(
            Icons.folder_outlined,
            size: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Category',
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class CategoryLoadingState extends StatelessWidget {
  const CategoryLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black38,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading categories...',
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: Colors.black38,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
