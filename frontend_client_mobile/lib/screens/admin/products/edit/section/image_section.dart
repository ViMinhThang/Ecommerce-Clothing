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
    final currentImage = viewModel.existingProduct?.imageUrl;
    final selectedImage = viewModel.selectedImage;

    final hasImage =
        selectedImage != null ||
        (currentImage != null && currentImage.isNotEmpty);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasImage)
          selectedImage != null
              ? Image.file(File(selectedImage.path), fit: BoxFit.cover)
              : Image.network(
                  ImageHelper.getFullImageUrl(currentImage),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholder(),
                )
        else
          _buildPlaceholder(),

        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),

        // Edit Button Layer
        Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: viewModel.pickImage,
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

        Positioned(
          bottom: 16,
          left: 16,
          child: Text(
            'PRODUCT IMAGE',
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
        ),
      ],
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
