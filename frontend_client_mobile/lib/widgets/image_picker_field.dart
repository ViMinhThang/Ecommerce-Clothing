import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerField extends StatelessWidget {
  final String? currentImage;
  final File? selectedImage;
  final VoidCallback onPickImage;

  const ImagePickerField({
    super.key,
    required this.currentImage,
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = selectedImage != null
        ? FileImage(selectedImage!)
        : (currentImage != null && currentImage!.isNotEmpty
              ? NetworkImage(currentImage!)
              : const AssetImage('assets/placeholder.png') as ImageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onPickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.upload),
              label: const Text('Choose an image'),
            ),
          ],
        ),
      ],
    );
  }
}
