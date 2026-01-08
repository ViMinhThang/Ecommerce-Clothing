import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:frontend_client_mobile/utils/image_helper.dart';
import 'image_widgets.dart';

/// Horizontal thumbnail strip for image management
class ImageThumbnailStrip extends StatelessWidget {
  final EditProductViewModel viewModel;
  final List existingImages;
  final List selectedImages;
  final bool hasImages;

  const ImageThumbnailStrip({
    super.key,
    required this.viewModel,
    required this.existingImages,
    required this.selectedImages,
    required this.hasImages,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: hasImages ? _buildThumbnailList() : _buildEmptyHint(),
      ),
    );
  }

  Widget _buildThumbnailList() {
    return SizedBox(
      height: 72,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...existingImages.asMap().entries.map((entry) {
            final img = entry.value;
            return ImageThumbnail(
              child: Image.network(
                ImageHelper.getFullImageUrl(img.imageUrl),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const BrokenImagePlaceholder(),
              ),
              onDelete: () => viewModel.removeExistingImage(img.id),
              isPrimary: img.isPrimary,
            );
          }),
          ...selectedImages.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return ImageThumbnail(
              child: Image.file(File(file.path), fit: BoxFit.cover),
              onDelete: () => viewModel.removeSelectedImage(index),
              isPrimary: existingImages.isEmpty && index == 0,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyHint() {
    return Center(
      child: Text(
        'Tap to upload product images',
        style: GoogleFonts.outfit(
          fontSize: 10,
          color: Colors.white38,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

/// Individual image thumbnail with delete and primary badge
class ImageThumbnail extends StatelessWidget {
  final Widget child;
  final VoidCallback onDelete;
  final bool isPrimary;

  const ImageThumbnail({
    super.key,
    required this.child,
    required this.onDelete,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 72,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
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
          _ThumbnailDeleteButton(onDelete: onDelete),
          if (isPrimary) const _ThumbnailPrimaryBadge(),
        ],
      ),
    );
  }
}

class _ThumbnailDeleteButton extends StatelessWidget {
  final VoidCallback onDelete;

  const _ThumbnailDeleteButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }
}

class _ThumbnailPrimaryBadge extends StatelessWidget {
  const _ThumbnailPrimaryBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
    );
  }
}
