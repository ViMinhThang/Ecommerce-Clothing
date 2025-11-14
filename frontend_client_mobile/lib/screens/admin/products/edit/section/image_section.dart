import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../../../widgets/image_picker_field.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context);
    // Need to get product from parent widget - pass via constructor if needed
    // For now, using a small hack to get it from the ViewModel's existingProduct
    final currentImage = viewModel.existingProduct?.imageUrl;

    return ImagePickerField(
      currentImage: currentImage,
      selectedImage: viewModel.selectedImage,
      onPickImage: viewModel.pickImage,
    );
  }
}
