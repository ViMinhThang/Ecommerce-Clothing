import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import '../../../../../utils/image_helper.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key});

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);
    final existingImages = viewModel.existingImages;
    final selectedImages = viewModel.selectedImages;

    final bool hasImages =
        existingImages.isNotEmpty || selectedImages.isNotEmpty;
    final int totalImages = existingImages.length + selectedImages.length;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background - show first image or placeholder
        if (hasImages)
          _buildMainImage(existingImages, selectedImages)
        else
          _buildPlaceholder(),

        // Technical Pattern Overlay
        Positioned.fill(
          child: Opacity(
            opacity: 0.15,
            child: CustomPaint(painter: _TechnicalPatternPainter()),
          ),
        ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.4, 1.0],
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Add image button (centered) - animated pulsing ring
        Center(
          child: GestureDetector(
            onTap: viewModel.pickImages,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
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
                    scale: hasImages ? 1.0 : _pulseAnimation.value,
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
                            hasImages
                                ? Icons.add
                                : Icons.camera_enhance_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hasImages ? 'ADD_VISUAL' : 'INIT_UPLOAD',
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
        ),

        // Top right image count badge
        if (hasImages)
          Positioned(
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
                    '$totalImages UNITS',
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
          ),

        // Bottom section with thumbnails
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image thumbnails
                if (hasImages)
                  SizedBox(
                    height: 72,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Existing images
                        ...existingImages.asMap().entries.map((entry) {
                          final img = entry.value;
                          return _buildThumbnail(
                            child: Image.network(
                              ImageHelper.getFullImageUrl(img.imageUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.white38,
                                      size: 20,
                                    ),
                                  ),
                            ),
                            onDelete: () =>
                                viewModel.removeExistingImage(img.id),
                            isPrimary: img.isPrimary,
                          );
                        }),
                        // Newly selected images
                        ...selectedImages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final file = entry.value;
                          return _buildThumbnail(
                            child: Image.file(
                              File(file.path),
                              fit: BoxFit.cover,
                            ),
                            onDelete: () =>
                                viewModel.removeSelectedImage(index),
                            isPrimary: existingImages.isEmpty && index == 0,
                          );
                        }),
                      ],
                    ),
                  )
                else
                  // Hint text when no images
                  Center(
                    child: Text(
                      'ACTIVATE_OPTICAL_SENSORS_TO_PROCEED',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: Colors.white38,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainImage(List existingImages, List selectedImages) {
    if (selectedImages.isNotEmpty) {
      return Image.file(File(selectedImages.first.path), fit: BoxFit.cover);
    } else if (existingImages.isNotEmpty) {
      return Image.network(
        ImageHelper.getFullImageUrl(existingImages.first.imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildThumbnail({
    required Widget child,
    required VoidCallback onDelete,
    required bool isPrimary,
  }) {
    return Container(
      width: 64,
      height: 72,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          // Image container
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: AppTheme.borderRadiusXS,
              border: Border.all(
                color: isPrimary
                    ? const Color(0xFFFFD700)
                    : Colors.white.withValues(alpha: 0.2),
                width: isPrimary ? 1.5 : 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: AppTheme.borderRadiusXS,
              child: child,
            ),
          ),

          // Delete button
          Positioned(
            top: -2,
            right: -2,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red[500],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 10),
              ),
            ),
          ),

          // Primary badge
          if (isPrimary)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    'MAIN',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: _TechnicalPatternPainter()),
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
                  'OPTICAL_DATA_NULL',
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

class _TechnicalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    // Grid
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

    // Markings
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
