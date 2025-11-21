import 'package:flutter/material.dart';

/// Elegant black and white theme configuration
class AppTheme {
  // Colors
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color darkGray = Color(0xFF2D2D2D);
  static const Color mediumGray = Color(0xFF6B6B6B);
  static const Color lightGray = Color(0xFF9E9E9E);
  static const Color veryLightGray = Color(0xFFE0E0E0);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color background = Color(
    0xFFF5F7FA,
  ); // Cool light gray for better contrast

  // State Colors
  static Color hoverOverlay = primaryBlack.withOpacity(0.05);
  static Color pressedOverlay = primaryBlack.withOpacity(0.1);
  static Color disabledBackground = veryLightGray;
  static Color disabledText = lightGray;

  // Glassmorphism
  static const double glassBlurStrength = 10.0;
  static const double glassOpacity = 0.15;
  static Color glassTint = primaryWhite.withOpacity(glassOpacity);
  static Color glassBorder = primaryWhite.withOpacity(0.2);

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;

  static BorderRadius borderRadiusXS = BorderRadius.circular(radiusXS);
  static BorderRadius borderRadiusSM = BorderRadius.circular(radiusSM);
  static BorderRadius borderRadiusMD = BorderRadius.circular(radiusMD);
  static BorderRadius borderRadiusLG = BorderRadius.circular(radiusLG);
  static BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;

  // Shadows
  static List<BoxShadow> shadowSM = [
    BoxShadow(
      color: primaryBlack.withOpacity(
        0.08,
      ), // Increased from 0.05 for better separation
      blurRadius: 8, // Increased from 4 for more depth
      offset: const Offset(0, 2), // Increased from 1 for more elevation
    ),
  ];

  static List<BoxShadow> shadowMD = [
    BoxShadow(
      color: primaryBlack.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLG = [
    BoxShadow(
      color: primaryBlack.withOpacity(0.1),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // Borders
  static Border borderThin = Border.all(
    color: const Color(0xFFB0B0B0), // Visible mid-gray
    width: 1.0,
  );
  static Border borderMedium = Border.all(color: lightGray, width: 1.5);
  static Border borderThick = Border.all(color: mediumGray, width: 2.0);
  static Border borderBlack = Border.all(color: primaryBlack, width: 1.0);

  // Animation
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);

  static const Curve curveDefault = Curves.easeInOutCubic;
  static const Curve curveEnter = Curves.easeOut;
  static const Curve curveExit = Curves.easeIn;
  static const Curve curveSharp = Curves.easeOutCubic;

  // Typography
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryBlack,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryBlack,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryBlack,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryBlack,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: primaryBlack,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: primaryBlack,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: mediumGray,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: lightGray,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: mediumGray,
    letterSpacing: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
