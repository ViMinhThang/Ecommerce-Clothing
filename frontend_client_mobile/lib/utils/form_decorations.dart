import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';

/// Utility class for common form input decorations
/// Provides consistent styling for form fields across the application
class FormDecorations {
  /// Standard input decoration for form fields
  static InputDecoration standard(String label) => InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.outfit(
      color: AppTheme.mediumGray,
      fontWeight: FontWeight.w700,
      fontSize: 10,
      letterSpacing: 1.5,
    ),
    border: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: AppTheme.mediumGray, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spaceMD,
      vertical: 14,
    ),
    filled: true,
    fillColor: AppTheme.primaryWhite,
  );
}
