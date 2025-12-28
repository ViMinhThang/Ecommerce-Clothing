// Minimal Chip styled like a simple text link or button
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap; // Add onTap property

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap, // Initialize onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Label Text
            Text(
              label,
              style: GoogleFonts.lora(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 4), // Space between text and dot

            if (isSelected)
              Container(
                width: 5, // Dot width
                height: 5, // Dot height
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
