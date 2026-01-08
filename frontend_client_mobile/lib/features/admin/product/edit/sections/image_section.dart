import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/product/edit/widgets/image_thumbnail_widgets.dart';
import 'package:frontend_client_mobile/features/admin/product/edit/widgets/image_widgets.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';

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
    final hasImages = existingImages.isNotEmpty || selectedImages.isNotEmpty;
    final totalImages = existingImages.length + selectedImages.length;

    return Stack(
      fit: StackFit.expand,
      children: [
        ImageBackground(
          existingImages: existingImages,
          selectedImages: selectedImages,
          hasImages: hasImages,
        ),
        const ImageGradientOverlay(),
        ImageUploadButton(
          onTap: viewModel.pickImages,
          hasImages: hasImages,
          animation: _pulseAnimation,
        ),
        if (hasImages) ImageCounter(count: totalImages),
        ImageThumbnailStrip(
          viewModel: viewModel,
          existingImages: existingImages,
          selectedImages: selectedImages,
          hasImages: hasImages,
        ),
      ],
    );
  }
}
