import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/image_helper.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);
    final existingImages = viewModel.existingImages;
    final selectedImages = viewModel.selectedImages;

    final bool hasImages =
        existingImages.isNotEmpty || selectedImages.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background - show first image or placeholder
        if (hasImages)
          _buildMainImage(existingImages, selectedImages)
        else
          _buildPlaceholder(),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),

        // Add image button (centered)
        Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: viewModel.pickImages,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),

        // Bottom section with label and image thumbnails
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRODUCT IMAGES (${existingImages.length + selectedImages.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 12,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Image thumbnails
                if (hasImages)
                  SizedBox(
                    height: 60,
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
                                  const Icon(
                                    Icons.broken_image,
                                    color: Colors.white54,
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
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPrimary ? Colors.yellow : Colors.white54,
          width: isPrimary ? 2 : 1,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(7), child: child),
          // Delete button
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
          // Primary badge
          if (isPrimary)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                child: const Text(
                  'MAIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'NO IMAGE SELECTED',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
