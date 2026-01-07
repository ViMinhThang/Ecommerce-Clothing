import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme_config.dart';

/// Reusable search bar widget for admin screens
/// Provides consistent styling and behavior across all management screens
class AdminSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AdminSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: AppTheme.borderRadiusXS,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: GoogleFonts.inter(fontSize: 13, color: AppTheme.primaryBlack),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 18, color: Colors.black38),
          hintText: hintText.toUpperCase(),
          hintStyle: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black26,
            letterSpacing: 1.5,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
