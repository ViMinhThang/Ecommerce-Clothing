import 'package:flutter/material.dart';

/// Elegant black and white theme configuration with Glassmorphism support
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
    0xFFF0F2F5,
  ); // Slightly darker for glass contrast

  // Gradients
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C2C2C), Color(0xFF000000)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xCCFFFFFF), // White with 80% opacity
      Color(0x99FFFFFF), // White with 60% opacity
    ],
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xCC000000), Color(0x99000000)],
  );

  // State Colors
  static Color hoverOverlay = primaryBlack.withOpacity(0.05);
  static Color pressedOverlay = primaryBlack.withOpacity(0.1);
  static Color disabledBackground = veryLightGray;
  static Color disabledText = lightGray;

  // Glassmorphism
  static const double glassBlurStrength = 16.0;
  static const double glassOpacity = 0.7;
  static Color glassTint = primaryWhite.withOpacity(glassOpacity);
  static Color glassBorder = primaryWhite.withOpacity(0.5);

  static BoxDecoration glassDecoration = BoxDecoration(
    color: primaryWhite.withOpacity(0.7),
    borderRadius: BorderRadius.circular(radiusLG),
    border: Border.all(color: primaryWhite.withOpacity(0.5), width: 1.5),
    boxShadow: shadowGlass,
  );

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radius2XL = 32.0;

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
      color: primaryBlack.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMD = [
    BoxShadow(
      color: primaryBlack.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> shadowLG = [
    BoxShadow(
      color: primaryBlack.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> shadowGlass = [
    BoxShadow(
      color: primaryBlack.withOpacity(0.05),
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  // Borders
  static Border borderThin = Border.all(
    color: const Color(0xFFE0E0E0),
    width: 1.0,
  );
  static Border borderMedium = Border.all(color: lightGray, width: 1.5);
  static Border borderThick = Border.all(color: mediumGray, width: 2.0);
  static Border borderBlack = Border.all(color: primaryBlack, width: 1.0);

  // Animation
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  static const Curve curveDefault = Curves.easeInOutCubic;
  static const Curve curveEnter = Curves.easeOutQuart;
  static const Curve curveExit = Curves.easeInQuart;
  static const Curve curveSharp = Curves.easeOutExpo;

  // Typography
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryBlack,
    letterSpacing: -1.0,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryBlack,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryBlack,
    letterSpacing: -0.5,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryBlack,
    letterSpacing: -0.5,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: primaryBlack,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: primaryBlack,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: mediumGray,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: lightGray,
    letterSpacing: 0.5,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: mediumGray,
    letterSpacing: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
