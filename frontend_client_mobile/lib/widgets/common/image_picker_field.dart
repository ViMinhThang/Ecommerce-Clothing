import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/theme_config.dart';

class ImagePickerField extends StatelessWidget {
  final String? currentImage;
  final XFile? selectedImage;
  final VoidCallback onPickImage;
  final String label;

  const ImagePickerField({
    super.key,
    required this.currentImage,
    required this.selectedImage,
    required this.onPickImage,
    this.label = 'IMAGE',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, color: AppTheme.primaryBlack),
              const SizedBox(width: 12),
              Text(
                label.toUpperCase(),
                style: AppTheme.h4.copyWith(
                  fontSize: 14,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLG),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePreview(),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: onPickImage,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlack,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 16,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      icon: const Icon(Icons.add_a_photo_outlined, size: 20),
                      label: Text(
                        'UPLOAD NEW IMAGE',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Max file size: 5MB\nSupported: JPG, PNG, WEBP',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.mediumGray,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    final hasImage =
        selectedImage != null ||
        (currentImage != null && currentImage!.isNotEmpty);

    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: hasImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: selectedImage != null
                  ? Image.file(File(selectedImage!.path), fit: BoxFit.cover)
                  : Image.network(
                      currentImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    ),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 32, color: AppTheme.mediumGray),
          const SizedBox(height: 12),
          Text(
            'NO IMAGE',
            style: AppTheme.caption.copyWith(
              color: AppTheme.mediumGray,
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
