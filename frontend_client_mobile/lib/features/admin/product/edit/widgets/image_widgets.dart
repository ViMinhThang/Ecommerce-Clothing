import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:frontend_client_mobile/utils/image_helper.dart';

/// Background with main image and technical pattern overlay
class ImageBackground extends StatelessWidget {
  final List existingImages;
  final List selectedImages;
  final bool hasImages;

  const ImageBackground({
    super.key,
    required this.existingImages,
    required this.selectedImages,
    required this.hasImages,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasImages) _buildMainImage() else const ImagePlaceholder(),
        Positioned.fill(
          child: Opacity(
            opacity: 0.15,
            child: CustomPaint(painter: TechnicalPatternPainter()),
          ),
        ),
      ],
    );
  }

  Widget _buildMainImage() {
    if (selectedImages.isNotEmpty) {
      return Image.file(File(selectedImages.first.path), fit: BoxFit.cover);
    } else if (existingImages.isNotEmpty) {
      return Image.network(
        ImageHelper.getFullImageUrl(existingImages.first.imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const ImagePlaceholder(),
      );
    }
    return const ImagePlaceholder();
  }
}

/// Gradient overlay for image section
class ImageGradientOverlay extends StatelessWidget {
  const ImageGradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 1.0],
          colors: [
            Colors.black.withValues(alpha: 0.4),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
    );
  }
}

/// Animated upload button
class ImageUploadButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasImages;
  final Animation<double> animation;

  const ImageUploadButton({
    super.key,
    required this.onTap,
    required this.hasImages,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: AppTheme.borderRadiusXS,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Transform.scale(
                scale: hasImages ? 1.0 : animation.value,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: AppTheme.borderRadiusXS,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        hasImages ? Icons.add : Icons.camera_enhance_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasImages ? 'Add More' : 'Upload',
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Image count badge
class ImageCounter extends StatelessWidget {
  final int count;

  const ImageCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 56,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              '$count images',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for empty state
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: TechnicalPatternPainter()),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 16),
                Text(
                  'No images',
                  style: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.2),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder for broken images
class BrokenImagePlaceholder extends StatelessWidget {
  const BrokenImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: const Icon(Icons.broken_image, color: Colors.white38, size: 20),
    );
  }
}

/// Technical grid pattern painter
class TechnicalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    for (var i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    paint.color = Colors.white.withValues(alpha: 0.1);
    canvas.drawLine(
      const Offset(20, 20),
      const Offset(50, 20),
      paint..strokeWidth = 2,
    );
    canvas.drawLine(const Offset(20, 20), const Offset(20, 50), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
