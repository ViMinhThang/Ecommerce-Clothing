import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';

class DiscountTypeLabel extends StatelessWidget {
  const DiscountTypeLabel({super.key});

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
            Icons.category_outlined,
            size: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Discount Type',
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

class DiscountTypeOption extends StatelessWidget {
  final String type;
  final String label;
  final IconData icon;
  final String currentType;
  final ValueChanged<String> onChanged;

  const DiscountTypeOption({
    super.key,
    required this.type,
    required this.label,
    required this.icon,
    required this.currentType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = currentType == type;
    return GestureDetector(
      onTap: () => onChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: AppTheme.borderRadiusXS,
          border: Border.all(
            color: selected
                ? Colors.black
                : Colors.black.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Colors.black,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
